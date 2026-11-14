//! vr offset extractor: recover the W1c write target
//! (`__tracepoint_sys_exit->funcs`, as a member offset inside
//! `struct tracepoint`, e.g. 72 for the 6.6.89-android15-8 profile) from a
//! boot.img / payload.bin / OTA source.
//!
//! The engine is GhostLock's own extractor (tools/extract_rs), used as a path
//! dependency; this crate only wires the input plumbing (boot image vs
//! payload.bin vs OTA ZIP, local file vs HTTP URL) and reports JSON.

use std::path::PathBuf;
use std::sync::Arc;

use anyhow::Context;

/// GhostLock profile 提取（boot.img / payload.bin / OTA → HOCON）。
pub mod profile;

/// Progress callback: `(phase, done, total)` where phase is 0 = download,
/// 1 = extraction. Units are bytes for phase 0, operations for phase 1.
pub type ProgressFn = dyn Fn(u32, u64, u64) + Sync + Send;

/// Run the whole pipeline. `input` is a boot.img / payload.bin / OTA ZIP path,
/// or an http(s) URL to any of those. Returns a JSON object:
///   { "ok": true, "member": 72, "abs": 36315432, "tp": 36315360,
///     "funcs_off": 72, "release": "6.6.89-..." }
/// or { "ok": false, "error": "..." }.
pub fn derive_json(
    input: &str,
    work_dir: &str,
    insecure: bool,
    progress: Option<Arc<ProgressFn>>,
) -> String {
    match run(input, work_dir, insecure, progress) {
        Ok(v) => v.to_string(),
        Err(err) => {
            serde_json::json!({ "ok": false, "error": format!("{err:#}") }).to_string()
        }
    }
}

fn run(
    input: &str,
    work_dir: &str,
    insecure: bool,
    progress: Option<Arc<ProgressFn>>,
) -> anyhow::Result<serde_json::Value> {
    let work = PathBuf::from(work_dir).join("vrext");
    std::fs::create_dir_all(&work).with_context(|| format!("mkdir {}", work.display()))?;

    // ---- 1) obtain a boot image file path -----------------------------
    let boot_path: PathBuf = if ghostlock_extract::payload::looks_like_payload(input) {
        let want = vec!["boot".to_string()];
        let cb: Option<payload_extract::input::ProgressCallback> = progress.map(|p| {
            Arc::new(move |done: u64, total: u64| p(0, done, total))
                as payload_extract::input::ProgressCallback
        });
        let view = payload_extract::input::open_for_extract_with(
            input,
            &want,
            &payload_extract::input::OpenOptions {
                insecure,
                temp_dir: Some(work.clone()),
                download_progress: cb,
                ..Default::default()
            },
        )?;
        let produced = ghostlock_extract::payload::extract_partitions(&view, &work, &want)?;
        produced
            .into_iter()
            .next()
            .ok_or_else(|| anyhow::anyhow!("payload produced no boot image"))?
    } else {
        PathBuf::from(input)
    };

    // ---- 2) parse the boot image, decompress the kernel ---------------
    let boot = BootImage::load(&boot_path)?;
    let btf_at = boot.embedded_btf_at();
    let btf = match &btf_at {
        Some((_, blob)) => Some(Btf::new(blob)?),
        None => None,
    };

    // ---- 3) recover the embedded kallsyms table (no root needed) ------
    let ks = kallsyms_finder::recover(
        &boot.kernel,
        btf_at.as_ref().map(|(offset, blob)| (*offset, blob.len())),
    )
    .map_err(|err| anyhow::anyhow!("kallsyms: {err}"))?;
    let symbols = ks.symbols;

    let base = kallsyms::unique(&symbols, "_text")
        .or_else(|| kallsyms::unique(&symbols, "_head"))
        .ok_or_else(|| anyhow::anyhow!("_text/_head is not unique in kallsyms"))?;
    let (rel_symbols, sorted_offsets) = relative_symbols(&symbols, base);

    // ---- 4) derive the funcs field address from the iterator code -----
    let abs = derive_sys_exit_tp_funcs(&boot.kernel, &rel_symbols, &sorted_offsets, btf.as_ref())
        .map_err(|err| anyhow::anyhow!("derive: {err}"))?;

    // ---- 5) convert to a member offset ---------------------------------
    // Prefer the real symbol from kallsyms (GKI KALLSYMS_ALL carries data
    // symbols); fall back to the derivation's own struct base (funcs_off
    // from BTF, else the extractor's 0x48 default).
    let funcs_off = btf
        .as_ref()
        .and_then(|b| b.field("tracepoint", "funcs"))
        .unwrap_or(0x48);
    let tp = kallsyms::unique(&symbols, "__tracepoint_sys_exit")
        .map(|v| v.wrapping_sub(base))
        .or_else(|| abs.checked_sub(u64::from(funcs_off)))
        .ok_or_else(|| anyhow::anyhow!("cannot locate __tracepoint_sys_exit"))?;
    let member = abs.checked_sub(tp).ok_or_else(|| {
        anyhow::anyhow!("funcs field precedes tracepoint struct ({abs:#x} < {tp:#x})")
    })?;
    if member == 0 || member > 0x100 {
        anyhow::bail!("implausible funcs member offset {member} (abs {abs:#x}, tp {tp:#x})");
    }

    let mut out = serde_json::json!({
        "ok": true,
        "member": member,
        "abs": abs,
        "tp": tp,
        "funcs_off": funcs_off,
    });
    if let Some(release) = boot.release() {
        out["release"] = serde_json::Value::String(release);
    }
    Ok(out)
}

use ghostlock_extract::btf::Btf;
use ghostlock_extract::boot::BootImage;
use ghostlock_extract::derive::{derive_sys_exit_tp_funcs, relative_symbols};
use ghostlock_extract::kallsyms;
use ghostlock_extract::kallsyms_finder;

/// 解析用户手填的物理装载基址：支持 `0x` 前缀与十进制；空串或非法值返回 None。
pub fn parse_phys(text: &str) -> Option<u64> {
    let trimmed = text.trim();
    if trimmed.is_empty() {
        return None;
    }
    let parsed = if let Some(hex) = trimmed
        .strip_prefix("0x")
        .or_else(|| trimmed.strip_prefix("0X"))
    {
        u64::from_str_radix(hex, 16)
    } else {
        trimmed.parse::<u64>()
    };
    parsed.ok()
}

/// 地址的十六进制字面量；None 输出空串，由 Kotlin 侧判断「未取到」。
pub fn hex_or_empty(value: Option<u64>) -> String {
    value.map(|v| format!("0x{v:x}")).unwrap_or_default()
}

// ---- JNI surface (Android only) -------------------------------------------
#[cfg(target_os = "android")]
mod jni {
    use std::sync::atomic::{AtomicU64, Ordering};
    use std::sync::Arc;

    use crate::ProgressFn;
    use jni::objects::{JClass, JString};
    use jni::sys::jboolean;
    use jni::JNIEnv;

    use super::{derive_json, hex_or_empty, parse_phys};

    /// Latest progress triplet, mirrored into Java so the UI can show it.
    static PROG_PHASE: AtomicU64 = AtomicU64::new(0);
    static PROG_DONE: AtomicU64 = AtomicU64::new(0);
    static PROG_TOTAL: AtomicU64 = AtomicU64::new(0);

    /// GhostLock profile 提取的进度，与 DirtyFrag 的 `PROG_*` 分开存放，
    /// 避免两条链路的轮询互相覆盖。
    static PROFILE_PHASE: AtomicU64 = AtomicU64::new(0);
    static PROFILE_DONE: AtomicU64 = AtomicU64::new(0);
    static PROFILE_TOTAL: AtomicU64 = AtomicU64::new(0);

    /// Called from Java on a poller thread: "phase done total", phase
    /// 0 = download (bytes), 1 = extraction (ops). Returned as a plain
    /// string to keep the native surface trivial to parse.
    #[no_mangle]
    pub extern "system" fn Java_org_supass_ai_1su_1pass_dirtyfrag_DirtyFragVrExtractor_nativeProgress<'local>(
        env: JNIEnv<'local>,
        _class: JClass,
    ) -> JString<'local> {
        let s = format!(
            "{} {} {}",
            PROG_PHASE.load(Ordering::Relaxed),
            PROG_DONE.load(Ordering::Relaxed),
            PROG_TOTAL.load(Ordering::Relaxed)
        );
        let j = env
            .new_string(s)
            .or_else(|_| env.new_string("0 0 0"))
            .map(JString::from);
        match j {
            Ok(v) => v,
            Err(e) => panic!("jni new_string failed twice: {e}"),
        }
    }

    /// Derive the vr funcs member offset. `input` = path or URL, `work_dir`
    /// = app cacheDir, `insecure` = skip TLS verification. Returns JSON.
    #[no_mangle]
    pub extern "system" fn Java_org_supass_ai_1su_1pass_dirtyfrag_DirtyFragVrExtractor_nativeDerive<'local>(
        mut env: JNIEnv<'local>,
        _class: JClass,
        input: JString<'local>,
        work_dir: JString<'local>,
        insecure: jboolean,
    ) -> JString<'local> {
        let input: String = env.get_string(&input).map(|s| s.into()).unwrap_or_default();
        let work: String = env
            .get_string(&work_dir)
            .map(|s| s.into())
            .unwrap_or_else(|_| "/data/local/tmp".into());
        let progress: Option<Arc<ProgressFn>> = Some(Arc::new(
            |phase, done, total| {
                PROG_PHASE.store(phase as u64, Ordering::Relaxed);
                PROG_DONE.store(done, Ordering::Relaxed);
                PROG_TOTAL.store(total, Ordering::Relaxed);
            },
        ));
        let json = derive_json(&input, &work, insecure == 1, progress);
        let j = env
            .new_string(json)
            .or_else(|_| {
                env.new_string(r#"{"ok":false,"error":"jni new_string failed"}"#)
            })
            .map(JString::from);
        match j {
            Ok(v) => v,
            Err(e) => panic!("jni new_string failed twice: {e}"),
        }
    }

    /// 轮询 GhostLock profile 提取进度：`"phase done total"`，
    /// phase 0 = 下载（字节），1 = 解包与解析，2 = 完成。
    #[no_mangle]
    pub extern "system" fn Java_org_supass_ai_1su_1pass_cve43499_GhostLockProfileExtractor_nativeProfileProgress<'local>(
        env: JNIEnv<'local>,
        _class: JClass,
    ) -> JString<'local> {
        let s = format!(
            "{} {} {}",
            PROFILE_PHASE.load(Ordering::Relaxed),
            PROFILE_DONE.load(Ordering::Relaxed),
            PROFILE_TOTAL.load(Ordering::Relaxed)
        );
        let j = env
            .new_string(s)
            .or_else(|_| env.new_string("0 0 0"))
            .map(JString::from);
        match j {
            Ok(v) => v,
            Err(e) => panic!("jni new_string failed twice: {e}"),
        }
    }

    /// 提取 GhostLock profile。符号名对应
    /// `org.supass.ai_su_pass.cve43499.GhostLockProfileExtractor`，与 DirtyFrag
    /// 的入口分离：两个 CVE 共用同一个 `.so`，但各自持有 JNI 类。
    /// 返回 `{"ok":true,"release":...,"conf":...,"warnings":[...],...}` 或
    /// `{"ok":false,"error":...,"analysis":...}`；不抛 Java 异常。
    #[no_mangle]
    pub extern "system" fn Java_org_supass_ai_1su_1pass_cve43499_GhostLockProfileExtractor_nativeDeriveProfile<'local>(
        mut env: JNIEnv<'local>,
        _class: JClass,
        input: JString<'local>,
        work_dir: JString<'local>,
        insecure: jboolean,
        xbl_path: JString<'local>,
        uefi_path: JString<'local>,
        vendor_boot_path: JString<'local>,
        phys: JString<'local>,
        kallsyms_path: JString<'local>,
        iomem_path: JString<'local>,
        route: JString<'local>,
        allow_missing: jboolean,
        no_disasm: jboolean,
    ) -> JString<'local> {
        let input: String = env.get_string(&input).map(|s| s.into()).unwrap_or_default();
        let work: String = env
            .get_string(&work_dir)
            .map(|s| s.into())
            .unwrap_or_else(|_| "/data/local/tmp".into());
        let xbl: String = env
            .get_string(&xbl_path)
            .map(|s| s.into())
            .unwrap_or_default();
        let uefi: String = env
            .get_string(&uefi_path)
            .map(|s| s.into())
            .unwrap_or_default();
        let vendor_boot: String = env
            .get_string(&vendor_boot_path)
            .map(|s| s.into())
            .unwrap_or_default();
        let phys_text: String = env
            .get_string(&phys)
            .map(|s| s.into())
            .unwrap_or_default();
        let kallsyms_text: String = env
            .get_string(&kallsyms_path)
            .map(|s| s.into())
            .unwrap_or_default();
        let iomem_text: String = env
            .get_string(&iomem_path)
            .map(|s| s.into())
            .unwrap_or_default();
        let route_text: String = env
            .get_string(&route)
            .map(|s| s.into())
            .unwrap_or_default();
        let phys_override = parse_phys(&phys_text);
        let options = crate::profile::ProfileOptions {
            insecure: insecure == 1,
            xbl_config: Some(xbl.as_str()),
            uefi: Some(uefi.as_str()),
            vendor_boot: Some(vendor_boot.as_str()),
            kallsyms: Some(kallsyms_text.as_str()),
            iomem: Some(iomem_text.as_str()),
            phys_override,
            route: Some(route_text.as_str()),
            allow_missing: allow_missing == 1,
            allow_disasm: no_disasm == 0,
        };
        PROFILE_PHASE.store(0, Ordering::Relaxed);
        PROFILE_DONE.store(0, Ordering::Relaxed);
        PROFILE_TOTAL.store(0, Ordering::Relaxed);
        let progress: Option<Arc<ProgressFn>> = Some(Arc::new(|phase, done, total| {
            PROFILE_PHASE.store(phase as u64, Ordering::Relaxed);
            PROFILE_DONE.store(done, Ordering::Relaxed);
            PROFILE_TOTAL.store(total, Ordering::Relaxed);
        }));
        let json = match crate::profile::derive_profile(
            &input,
            std::path::Path::new(&work),
            &options,
            progress,
        ) {
            Ok(derived) => serde_json::json!({
                "ok": derived.ok,
                "release": derived.release,
                "conf": derived.conf,
                "warnings": derived.warnings,
                "bootPath": derived.boot_path,
                "kernelPhysLoad": hex_or_empty(derived.kernel_phys_load),
                "kernelPhysOffset": hex_or_empty(derived.kernel_phys_offset),
                "physSource": derived.phys_source,
                "analysis": derived.analysis,
                "error": derived.error,
            })
            .to_string(),
            Err(err) => serde_json::json!({
                "ok": false,
                "error": err.to_string(),
                "analysis": "",
            })
            .to_string(),
        };
        let j = env
            .new_string(json)
            .or_else(|_| {
                env.new_string(r#"{"ok":false,"error":"jni new_string failed"}"#)
            })
            .map(JString::from);
        match j {
            Ok(v) => v,
            Err(e) => panic!("jni new_string failed twice: {e}"),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{hex_or_empty, parse_phys};

    #[test]
    fn parse_phys_accepts_hex_int_and_decimal() {
        assert_eq!(parse_phys("0x80000000"), Some(0x8000_0000));
        assert_eq!(parse_phys("0X80000000"), Some(0x8000_0000));
        assert_eq!(parse_phys("2151677952"), Some(2151677952));
        assert_eq!(parse_phys("  0x1000  "), Some(0x1000));
    }

    #[test]
    fn parse_phys_rejects_empty_and_garbage() {
        assert_eq!(parse_phys(""), None);
        assert_eq!(parse_phys("   "), None);
        assert_eq!(parse_phys("zzz"), None);
        assert_eq!(parse_phys("0x"), None);
    }

    #[test]
    fn hex_or_empty_formats_known_and_missing() {
        assert_eq!(hex_or_empty(None), "");
        assert_eq!(hex_or_empty(Some(0x8000_0000)), "0x80000000");
        assert_eq!(hex_or_empty(Some(0)), "0x0");
    }
}
