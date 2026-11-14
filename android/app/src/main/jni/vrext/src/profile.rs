//! GhostLock profile 提取：boot.img / Image / payload.bin / OTA ZIP / http(s) URL
//! → 自包含的 GLK HOCON 文本。
//!
//! 全部计算来自 `ghostlock_extract`（上游 423ccb1）。本模块只做参数编排与
//! 告警收集，不复制任何提取算法，因此上游更新时只需同步本文件的调用顺序。
//!
//! 与上游 CLI（`extract_rs/src/main.rs`）的差异：
//! - 只实现 `--format conf` 一条路径，JSON/text 输出不搬；
//! - 无 CLI 解析、无 stdout 打印：告警收进 [`Derived::warnings`] 由调用方展示；
//! - 内核审查报告始终生成（等价 `--analysis`），但不再单独 return。

use std::collections::{BTreeMap, BTreeSet};
use std::path::{Path, PathBuf};
use std::sync::Arc;

use crate::ProgressFn;

use ghostlock_extract::analysis;
use ghostlock_extract::boot::{BootImage, MTK_DEFAULT_PHYS_LOAD, MTK_VADDR_BASE};
use ghostlock_extract::btf::Btf;
use ghostlock_extract::derive::{
    derive_cred_5x, derive_nf_logger_registration, derive_pselect_layout,
    ensure_rtmutex_43499_unpatched, multicast_waiter_off, relative_symbols,
    PSELECT_ROUTE_NFDS,
};
use ghostlock_extract::error::{ExtractError, Result};
use ghostlock_extract::fdt::{recover_kernel_phys_load, recover_kernel_phys_load_from_uefi};
use ghostlock_extract::iomem;
use ghostlock_extract::kallsyms;
use ghostlock_extract::kallsyms::Kallsyms;
use ghostlock_extract::kallsyms_finder;
use ghostlock_extract::payload;
use ghostlock_extract::report;
use ghostlock_extract::symbols::{
    kernel_layout_verified, kernel_struct_macro, resolve_structs, resolve_symbols,
};
use ghostlock_extract::vendor_boot::recover_kernel_phys_from_vendor_boot;

/// 提取结果。
pub struct Derived {
    /// 是否产出了可用的 profile；false 时 [`Derived::conf`] 为空，失败
    /// 原因在 [`Derived::error`]，而 [`Derived::analysis`] 仍然可用。
    pub ok: bool,
    /// 内核 release，与 `uname -r` 逐字可比；解析早期失败时为空串。
    pub release: String,
    /// 自包含的 GLK profile（HOCON，无 `include`）。
    pub conf: String,
    /// 提取过程中的告警；不阻断，但调用方应展示。
    pub warnings: Vec<String>,
    /// 实际参与解析的 boot 镜像路径。
    ///
    /// OTA / payload 输入时指向解包后落在 `work_dir` 下的文件，调用方可以用
    /// 它复用同一份镜像，避免为另一套表再下载一次。
    pub boot_path: String,
    /// 内核物理装载基址；`None` 表示未取到。
    pub kernel_phys_load: Option<u64>,
    /// DRAM 基址；`None` 表示未取到。
    pub kernel_phys_offset: Option<u64>,
    /// `kernel_phys_load` 的来源；未取到为 `unset`。
    pub phys_source: &'static str,
    /// 内核审查报告（等价上游 `--analysis`）；解析早期失败时为空串。
    pub analysis: String,
    /// 失败原因；成功为空串。
    pub error: String,
}

/// 与上游 `--route` 的取值一致。
const ROUTE_NAMES: [&str; 3] = ["tcp_zerocopy", "select_stack", "multicast_waiter"];

/// 提取选项，对应上游 CLI 的参数集。
#[derive(Default)]
pub struct ProfileOptions<'a> {
    /// 跳过 TLS 校验（上游 `--insecure`）。
    pub insecure: bool,
    /// 附加 xbl_config.img（上游 `--xbl_config`）。
    pub xbl_config: Option<&'a str>,
    /// 附加 uefi.img（上游 `--uefi`）。
    pub uefi: Option<&'a str>,
    /// 附加 vendor_boot.img（上游 `--vendor_boot`，MediaTek）。
    pub vendor_boot: Option<&'a str>,
    /// 外部 kallsyms 文本（上游 `--kallsyms`）；空串表示自动。
    pub kallsyms: Option<&'a str>,
    /// 外部 /proc/iomem 文本（上游 `--iomem`）；空串表示自动。
    pub iomem: Option<&'a str>,
    /// 手填物理装载基址（上游 `--phys`）。
    pub phys_override: Option<u64>,
    /// 强制路由（上游 `--route`）；`None` 表示按内核自动推荐。
    pub route: Option<&'a str>,
    /// 缺失符号一律按可选输出 0（上游 `--allow_missing`）。
    pub allow_missing: bool,
    /// 是否启用反汇编推导（上游默认开启，`--no_disasm` 关闭）。
    pub allow_disasm: bool,
}

/// 提取 profile。
///
/// `input` 可以是本地路径（boot.img / Image / payload.bin / OTA zip）或
/// `http(s)` 直链。`work_dir` 由调用方给出（App 的 cacheDir），中间产物落在
/// 其下 `ghostlock/`。
///
/// `progress` 是可选回调 `(phase, done, total)`：phase 0 = 下载（字节），
/// 1 = 解包与解析（无确定总量，`total` 为 0）。纯计算阶段不逐条上报。
pub fn derive_profile(
    input: &str,
    work_dir: &Path,
    options: &ProfileOptions<'_>,
    progress: Option<Arc<ProgressFn>>,
) -> Result<Derived> {
    let mut warnings: Vec<String> = Vec::new();

    let report = |phase: u32, done: u64, total: u64| {
        if let Some(cb) = &progress {
            cb(phase, done, total);
        }
    };

    /* ---- 1. 输入归一：payload / OTA 先解出 boot ---- */
    let mut boot_path = PathBuf::from(input);
    // 调用方显式附加的镜像；payload 分支会以解出的分区为准。
    let mut xbl_path: Option<PathBuf> = options
        .xbl_config
        .filter(|path| !path.is_empty())
        .map(PathBuf::from);
    let mut uefi_path: Option<PathBuf> = options
        .uefi
        .filter(|path| !path.is_empty())
        .map(PathBuf::from);
    let mut vendor_boot_path: Option<PathBuf> = options
        .vendor_boot
        .filter(|path| !path.is_empty())
        .map(PathBuf::from);
    let phys_override = options.phys_override;

    if payload::looks_like_payload(input) {
        let payload_work: PathBuf = work_dir.join("ghostlock-payload");
        let meta_view = payload::open_payload_meta_with_insecure(input, options.insecure)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        let mut want = payload::analysis_partition_names(&meta_view)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        let available: Vec<String> = meta_view
            .partitions()
            .iter()
            .map(|p| p.partition_name.clone())
            .collect();
        /* 没有 xbl_config 时才用 vendor_boot 补 kernel_phys_load，
         * 避免多下一份大分区。 */
        if !want.iter().any(|name| name == "xbl_config")
            && available.iter().any(|name| name == "vendor_boot")
        {
            want.push("vendor_boot".to_string());
        }
        let download_cb: Option<payload_extract::input::ProgressCallback> =
            progress.as_ref().map(|cb| {
                let cb = Arc::clone(cb);
                Arc::new(move |done: u64, total: u64| cb(0, done, total))
                    as payload_extract::input::ProgressCallback
            });
        let payload_view = payload::open_payload_for(input, &payload_work, &want, download_cb)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        report(1, 0, 0);
        let produced = payload::extract_partitions(&payload_view, &payload_work, &want)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        let pick = |name: &str| -> Option<PathBuf> {
            produced
                .iter()
                .find(|path| {
                    path.file_name()
                        .map(|file| {
                            let file = file.to_string_lossy();
                            file == name || file == format!("{name}.img")
                        })
                        .unwrap_or(false)
                })
                .cloned()
        };
        let extracted_boot =
            pick("boot").ok_or_else(|| ExtractError::new("boot partition output not found"))?;
        let extracted_xbl = pick("xbl_config");
        let extracted_uefi = pick("uefi");
        let extracted_vendor_boot = pick("vendor_boot");
        boot_path = extracted_boot;
        warnings.push(format!("extracted from payload: {}", want.join(", ")));
        /* payload 里没有该分区时保留调用方附加的文件。 */
        if extracted_xbl.is_some() {
            xbl_path = extracted_xbl;
        } else if xbl_path.is_none() {
            warnings.push(format!(
                "payload manifest has no xbl_config partition; the XBL FDT cannot supply \
                 kernel_phys_load (xbl-like entries: {})",
                list_entries(&available, &["xbl"])
            ));
        }
        if extracted_uefi.is_some() {
            uefi_path = extracted_uefi;
        } else if uefi_path.is_none() {
            warnings.push(format!(
                "payload manifest has no uefi partition; the platform memory map is unavailable \
                 (uefi-like entries: {})",
                list_entries(&available, &["uefi"])
            ));
        }
        if extracted_vendor_boot.is_some() {
            vendor_boot_path = extracted_vendor_boot;
            warnings.push("vendor_boot extracted from payload".to_string());
        }
    }

    report(1, 0, 0);

    /* ---- 2. boot 解包 ---- */
    let boot = BootImage::load(&boot_path)?;

    /* ---- 3. kernel_phys_load：xbl FDT → uefi memory map → 手参 → vendor_boot → iomem ---- */
    let mut kernel_phys_load: Option<u64> = None;
    let mut phys_source = "unset";
    if let Some(xbl) = &xbl_path {
        match recover_kernel_phys_load(xbl) {
            Ok(phys) => {
                kernel_phys_load = Some(phys);
                phys_source = "xbl_config FDT";
            }
            Err(err) => warnings.push(format!(
                "xbl_config FDT parse failed: {err}; trying the uefi memory map"
            )),
        }
    }
    if kernel_phys_load.is_none() {
        if let Some(uefi) = &uefi_path {
            match recover_kernel_phys_load_from_uefi(uefi) {
                Ok(phys) => {
                    kernel_phys_load = Some(phys);
                    phys_source = "uefi memory map";
                }
                Err(err) => warnings.push(format!(
                    "uefi memory-map parse failed: {err}; proceeding with boot-only analysis"
                )),
            }
        }
    }
    if kernel_phys_load.is_none() {
        if let Some(phys) = phys_override {
            kernel_phys_load = Some(phys);
            phys_source = "manual";
        }
    }
    /* vendor_boot 头部的 kernel_addr 恒能给出 kernel_phys_load；DRAM 基址只在
     * 对齐模式能证明时才一并给出（见上游 vendor_boot::classify）。 */
    let mut vendor_boot_phys_offset: Option<u64> = None;
    if kernel_phys_load.is_none() {
        if let Some(path) = &vendor_boot_path {
            match recover_kernel_phys_from_vendor_boot(path) {
                Ok((load, offset)) => {
                    kernel_phys_load = Some(load);
                    phys_source = "vendor_boot header (MediaTek)";
                    vendor_boot_phys_offset = offset;
                }
                Err(err) => warnings.push(format!(
                    "vendor_boot header parse failed: {err}; trying other sources"
                )),
            }
        }
    }

    /* ---- 4. kallsyms：/proc/kallsyms 优先，否则从镜像内嵌表恢复 ---- */
    let btf_at = boot.embedded_btf_at();
    let ks = resolve_kallsyms(
        &boot,
        btf_at.as_ref().map(|(off, blob)| (*off, blob.len())),
        options.kallsyms,
    )?;
    let symbols = ks.symbols;
    let text_base = kallsyms::unique(&symbols, "_text");
    let base = text_base.or_else(|| kallsyms::unique(&symbols, "_head"));
    let Some(base) = base else {
        return Err(ExtractError::new("_text/_head is not unique in kallsyms"));
    };

    /* ---- 5. /proc/iomem：DRAM 基址，必要时反推 kernel_phys_load ---- */
    let mut kernel_phys_offset: Option<u64> = vendor_boot_phys_offset;
    let iomem_file: Option<PathBuf> = options
        .iomem
        .filter(|path| !path.is_empty())
        .map(PathBuf::from);
    let iomem_info = match iomem::load(iomem_file.as_deref()) {
        Ok(info) => info,
        Err(err) => {
            warnings.push(err.to_string());
            None
        }
    };
    if let Some(info) = iomem_info {
        if info.dram_base.is_some() {
            kernel_phys_offset = info.dram_base;
        }
        if kernel_phys_load.is_none() {
            if let (Some(kc), Some(text), Some(stext)) = (
                info.kernel_code_start,
                kallsyms::unique(&symbols, "_text"),
                kallsyms::unique(&symbols, "_stext"),
            ) {
                let delta = stext.wrapping_sub(text) & 0xffff_ffff;
                kernel_phys_load = Some(kc.wrapping_sub(delta) & 0xffff_ffff);
                phys_source = "iomem";
            }
        }
    }

    /* ---- 6. 漏洞是否存在：结果保留给审查报告，缺失时不立即中断 ---- */
    let (rel_symbols, sorted_offsets) = relative_symbols(&symbols, base);
    let primitive = ensure_rtmutex_43499_unpatched(&boot.kernel, &rel_symbols, &sorted_offsets);
    let primitive_failure = primitive.as_ref().err().map(|err| err.to_string());

    /* ---- 7. BTF ---- */
    let btf_raw = btf_at.as_ref().map(|(_, blob)| blob.clone());
    let btf = btf_raw.as_deref().map(Btf::new).transpose()?;
    if btf.is_none() {
        warnings.push(
            "embedded BTF not found; symbols come from kallsyms and struct offsets fall back \
             to target.h defaults"
                .to_string(),
        );
    }

    /* ---- 8. release 与 MediaTek 物理基址 ---- */
    let release = boot.release();
    match release.as_deref() {
        Some(text) => {
            if !kernel_layout_verified(Some(text)) {
                let template = kernel_struct_macro(Some(text));
                warnings.push(format!(
                    "{text} is unverified{}; no family-derived geometry will be emitted",
                    template.map_or(String::new(), |name| format!(" (template {name} only)"))
                ));
            }
        }
        None => warnings.push("boot image carries no kernel release string".to_string()),
    }
    if kernel_phys_load.is_none() && (boot.mtk_lz4 || boot.mtk_gzip) {
        if let Some(text_base) = text_base {
            match text_base.checked_sub(MTK_VADDR_BASE) {
                Some(derived) if derived == MTK_DEFAULT_PHYS_LOAD => {
                    kernel_phys_load = Some(derived);
                    phys_source = "MediaTek DRAM base";
                }
                _ => warnings.push(format!(
                    "_text=0x{text_base:x} does not match the mtk DRAM-base mapping; \
                     kernel_phys_load left unset so the runtime derives it"
                )),
            }
        } else {
            warnings.push(
                "MediaTek compressed image; _text unavailable, leaving kernel_phys_load unset \
                 so the runtime derives it"
                    .to_string(),
            );
        }
    }

    /* ---- 8.1 内核审查报告：与上游 --analysis 等价，供 UI 分诊 ---- */
    let analysis_text = analysis::render(&analysis::build(analysis::Input {
        release: release.as_deref(),
        kernel: &boot.kernel,
        symbols: &symbols,
        rel_symbols: &rel_symbols,
        sorted_offsets: &sorted_offsets,
        btf: btf.as_ref(),
        phys: kernel_phys_load,
        phys_source,
        primitive: primitive.map_err(|err| ExtractError::new(err.to_string())),
        allow_disasm: options.allow_disasm,
    }));
    if let Some(message) = primitive_failure {
        return Ok(Derived {
            ok: false,
            release: release.unwrap_or_default(),
            conf: String::new(),
            warnings,
            boot_path: boot_path.to_string_lossy().into_owned(),
            kernel_phys_load,
            kernel_phys_offset,
            phys_source,
            analysis: analysis_text,
            error: format!("primitive absent: {message}"),
        });
    }

    /* ---- 9. 符号与结构体偏移 ---- */
    let mut symbol_offsets = resolve_symbols(&symbols, base);

    /* 9.1 pselect 布局与 nf_logger 槽 —— 只有反汇编可得 */
    let mut derived: BTreeMap<String, u64> = BTreeMap::new();
    let mut pselect_infeasible: Option<String> = None;
    if !options.allow_disasm {
        warnings.push(
            "disassembly derivation disabled; pselect_waiter_shift and loggers_0_1 fall back to \
             heuristics"
                .to_string(),
        );
    } else if let Some(btf) = &btf {
        match derive_pselect_layout(
            &boot.kernel,
            &rel_symbols,
            &sorted_offsets,
            btf,
            PSELECT_ROUTE_NFDS,
        ) {
            Ok(layout) => {
                derived.insert(
                    "pselect_waiter_shift_value".to_string(),
                    (layout.shift as i64 - 2) as u64,
                );
            }
            Err(ExtractError::Infeasible(message)) => {
                warnings.push(format!(
                    "pselect route not feasible on this kernel: {message}"
                ));
                pselect_infeasible = Some(message);
            }
            Err(err) => warnings.push(format!("pselect_waiter_shift derivation failed: {err}")),
        }
        match derive_nf_logger_registration(&boot.kernel, &rel_symbols, &sorted_offsets, btf) {
            Ok(info) => {
                derived.insert("off_slide_loggers_0_1".to_string(), info.loggers_0_1);
            }
            Err(err) => warnings.push(format!("loggers_0_1 derivation failed: {err}")),
        }
    } else {
        warnings.push(
            "no BTF; loggers_0_1 falls back to the loggers+0x10 heuristic".to_string(),
        );
    }

    let pselect_shift = derived
        .get("pselect_waiter_shift_value")
        .copied()
        .map(|value| value as i64)
        .or_else(|| {
            /* infeasible 时不套用 family 默认值：该镜像没有这条布局 */
            if pselect_infeasible.is_some() {
                return None;
            }
            let shift = report::pselect_waiter_shift_for(release.as_deref());
            match shift {
                /* family 值是查表得来、不是本镜像实测，必须标出来 */
                Some(value) => warnings.push(format!(
                    "using verified-family pselect_waiter_shift={value}; image-specific \
                     disassembly derivation was unavailable"
                )),
                None => warnings.push(
                    "pselect_waiter_shift unavailable; no family fallback is defined for this \
                     release"
                        .to_string(),
                ),
            }
            shift
        });
    if let Some(slot) = derived.get("off_slide_loggers_0_1").copied() {
        symbol_offsets.insert("off_slide_loggers_0_1".to_string(), Some(slot));
    }

    /* 9.2 结构体偏移 */
    let mut struct_offsets = resolve_structs(btf.as_ref());
    /* vr_guard 段是 DirtyFrag 的，GhostLock 侧不读；摘掉后 render_conf 不会
     * 往 GLK profile 里写 `recommend_vr_guard` / `vr_guard`。 */
    struct_offsets.remove("vr_tracepoint_funcs");

    /* 9.3 可选符号缺失时填 0（运行期回退 target.h 默认值） */
    let missing: Vec<String> = symbol_offsets
        .iter()
        .filter(|(_, value)| value.is_none())
        .map(|(key, _)| key.clone())
        .collect();
    let mut tolerated: BTreeSet<String> = report::optional_symbols()
        .into_iter()
        .map(str::to_string)
        .collect();
    /* 上游 --allow_missing：把全部缺失符号都当作可选，按 0 输出。 */
    if options.allow_missing {
        tolerated.extend(missing.iter().cloned());
    }
    let mut tolerated_missing: Vec<String> = missing
        .iter()
        .filter(|key| tolerated.contains(*key))
        .cloned()
        .collect();
    tolerated_missing.sort();
    for key in &tolerated_missing {
        symbol_offsets.insert(key.clone(), Some(0));
        warnings.push(format!(
            "{key} not found in kallsyms; emitted 0x00000000 (runtime falls back to \
             target.h default)"
        ));
    }

    /* ---- 10. conf 是候选产物：缺字段留给 app 的校验去报 ---- */
    if let Err(err) = report::require_fields(&symbol_offsets, &BTreeSet::new()) {
        warnings.push(format!("{err}; writing an unverified candidate"));
    }
    if btf.is_some() {
        let struct_fields_u64: BTreeMap<String, Option<u64>> = struct_offsets
            .iter()
            .map(|(key, value)| (key.clone(), value.map(|v| v as u64)))
            .collect();
        if let Err(err) =
            report::require_fields(&struct_fields_u64, &report::optional_struct_fields())
        {
            warnings.push(format!("{err}; writing an unverified candidate"));
        }
    }

    /* ---- 11. route 选择 ---- */
    let release_text = release
        .as_deref()
        .ok_or_else(|| ExtractError::new("profile needs a kernel release string"))?;
    let major = release_text
        .split('.')
        .next()
        .and_then(|part| part.parse::<u32>().ok());
    if major != Some(5) && major != Some(6) {
        return Err(ExtractError::new(format!(
            "profile needs a 5.x/6.x release, got {release_text}"
        )));
    }

    /* ---- 11. route 选择：调用方强制优先，否则按内核推荐 ---- */
    let route = match options.route.filter(|name| !name.is_empty()) {
        Some(forced) => {
            if !ROUTE_NAMES.contains(&forced) {
                return Err(ExtractError::new(format!(
                    "unknown route '{forced}'; expected one of {}",
                    ROUTE_NAMES.join(", ")
                )));
            }
            Some(forced.to_string())
        }
        None => {
            let paths =
                analysis::probe_paths(&symbols, &boot.kernel, &rel_symbols, &sorted_offsets);
            let pselect_derived = derived.contains_key("pselect_waiter_shift_value");
            let (suggested, _, _) =
                analysis::suggest_route(pselect_derived, &paths, release.as_deref());
            suggested.map(str::to_string)
        }
    };
    if route
        .as_deref()
        .is_some_and(analysis::route_depends_on_pselect_layout)
    {
        if let Some(message) = &pselect_infeasible {
            return Err(ExtractError::new(format!(
                "pselect route not feasible on this kernel: {message}"
            )));
        }
    }

    /* 11.1 路由几何；multicast 的 waiter_off/buffer_size 必须镜像内推导得出 */
    let mut geometry = route
        .as_deref()
        .map(|name| {
            report::conf_route_geometry(name, release_text, pselect_shift, &struct_offsets)
        })
        .unwrap_or_default();
    if route.as_deref() == Some("multicast_waiter") {
        const MCAST_BUFFER_SIZE: u64 = 264;
        const RT_MUTEX_WAITER_PI_TREE_ENTRY: u64 = 0x18;
        match multicast_waiter_off(
            &boot.kernel,
            &rel_symbols,
            &sorted_offsets,
            MCAST_BUFFER_SIZE,
            RT_MUTEX_WAITER_PI_TREE_ENTRY,
        ) {
            /* conf_route_geometry 只给 BTF 能提供的那部分；帧常量由这里补齐，
             * 推导失败就不写，避免把硬件实测常量塞进未验证候选。 */
            Ok(geom) => {
                geometry.insert(0, ("waiter_off", geom.waiter_off as i64));
                geometry.insert(1, ("buffer_size", MCAST_BUFFER_SIZE as i64));
            }
            Err(err) => warnings.push(format!(
                "static multicast waiter_off derivation failed: {err}; \
                 omitting the frame/copy-window geometry (the candidate stays incomplete)"
            )),
        }
    }
    match route.as_deref() {
        Some(name) if geometry.is_empty() => warnings.push(format!(
            "no image-derived geometry for route {name}; writing an unverified candidate \
             route branch"
        )),
        None => warnings.push(
            "no route could be inferred; writing release/common fields only".to_string(),
        ),
        Some(_) => {}
    }
    if route.as_deref() == Some("multicast_waiter")
        && !geometry.iter().any(|(key, _)| *key == "task_offset")
    {
        warnings.push(
            "rt_mutex_waiter task/lock offsets are missing from BTF; the multicast geometry \
             is partial"
                .to_string(),
        );
    }

    /* ---- 12. credential 模板：5.x 反汇编推导，6.x 用共享常量 ---- */
    let cred: Vec<(String, String)> = if major == Some(5) {
        let derived_cred = btf.as_ref().and_then(|btf| {
            let init_cred_off = symbol_offsets.get("off_init_cred").copied().flatten()?;
            let size = btf.size("cred")?;
            match derive_cred_5x(btf, &boot.kernel, init_cred_off) {
                Ok(cred) => Some(report::conf_cred_5x(&cred, size)),
                Err(err) => {
                    warnings.push(format!("5.x credential derivation failed: {err}"));
                    None
                }
            }
        });
        match derived_cred {
            Some(cred) => cred,
            None => {
                warnings.push(
                    "credential template omitted; the built-in profile must supply it"
                        .to_string(),
                );
                Vec::new()
            }
        }
    } else {
        report::conf_cred_6x()
    };

    let extra_offsets = report::ConfExtraOffsets {
        empty_zero_page: kallsyms::unique(&symbols, "empty_zero_page")
            .and_then(|value| value.checked_sub(base)),
        /* vr.ko 的 guard 目标：GhostLock 原生侧从不读取，85 份内置表也都没有这个键。
         * 上游 CLI 只有在内核暴露 __tracepoint_sys_exit 时才推导，这里直接留空。 */
        sys_exit_tp_funcs: None,
    };

    let conf = report::render_conf(&report::ConfInputs {
        release: release_text,
        phys: kernel_phys_load,
        /* DRAM 基址：只有在 rooted 设备上读到 /proc/iomem 时才有值 */
        phys_offset: kernel_phys_offset,
        symbols: &symbol_offsets,
        structs: &struct_offsets,
        route: route.as_deref(),
        route_geometry: &geometry,
        cred: &cred,
        extra_offsets: &extra_offsets,
    });

    report(2, 1, 1);
    Ok(Derived {
        ok: true,
        release: release_text.to_string(),
        conf,
        warnings,
        boot_path: boot_path.to_string_lossy().into_owned(),
        kernel_phys_load,
        kernel_phys_offset,
        phys_source,
        analysis: analysis_text,
        error: String::new(),
    })
}

/// 从 manifest 的分区名里挑出含任一关键词的条目；没有时返回 `none`。
fn list_entries(available: &[String], keywords: &[&str]) -> String {
    let hits: Vec<&str> = available
        .iter()
        .filter(|name| keywords.iter().any(|keyword| name.contains(keyword)))
        .map(String::as_str)
        .collect();
    if hits.is_empty() {
        "none".to_string()
    } else {
        hits.join(", ")
    }
}

/// 取 kallsyms：显式文件 → `/proc/kallsyms` → 镜像内嵌表。
///
/// 显式文件解析失败直接报错（上游 `--kallsyms` 语义：给了就必须用）；
/// `/proc` 里地址全为 0（`kptr_restrict`）视为不可用，继续回退。
fn resolve_kallsyms(
    boot: &BootImage,
    btf_at: Option<(usize, usize)>,
    provided: Option<&str>,
) -> Result<Kallsyms> {
    if let Some(path) = provided.filter(|path| !path.is_empty()) {
        let text = std::fs::read_to_string(path).map_err(|err| {
            ExtractError::new(format!("cannot read kallsyms '{path}': {err}"))
        })?;
        return kallsyms::parse(&text)
            .map_err(|err| ExtractError::new(format!("cannot parse kallsyms '{path}': {err}")));
    }
    let proc_ksyms = Path::new("/proc/kallsyms");
    if proc_ksyms.is_file() && std::fs::File::open(proc_ksyms).is_ok() {
        if let Ok(text) = std::fs::read_to_string(proc_ksyms) {
            if let Ok(ks) = kallsyms::parse(&text) {
                if ks
                    .symbols
                    .values()
                    .any(|addrs| addrs.iter().any(|&a| a != 0))
                {
                    return Ok(ks);
                }
            }
        }
    }
    kallsyms_finder::recover(&boot.kernel, btf_at)
        .map_err(|err| ExtractError::kallsyms(err.to_string()))
}
