# 第三方开源声明

本文件是第三方组件、许可证与修改记录的**唯一权威来源**；`README.md` / `README_ZH.md` 只保留摘要。

约定：

- 组件按交付层分组，每行给出上游仓库、固定版本、许可证、取用内容、落位与对上游的改动。
- 版本号与「逐字节一致」由本地 `.bin/` 克隆（已 gitignore）做 SHA-256 比对得出，描述当前工作树，不跟随上游 `HEAD`。
- **未列为「改动」的文件均与上游逐字节一致**。修改声明的措辞对应 Apache-2.0 §4(b) 与 GPL-2.0 §2(a) 的要求。

## 1. shell 通道与解压依赖

无线调试配对、ADB 协议、shell 流与 `payload.bin` 解压全部使用现成工件，仓库内无自研实现，也未修改其代码。

| 组件 | 版本 | 许可证 | 取用内容 | 落位 | 改动 |
| --- | --- | --- | --- | --- | --- |
| [MuntashirAkon/libadb-android](https://github.com/MuntashirAkon/libadb-android) | 3.1.1 | `GPL-3.0-or-later OR Apache-2.0`（本项目按 Apache-2.0 使用） | SPAKE2 配对、TLS 连接、`shell:` 流 | JitPack AAR，入口 `kotlin/.../core/adb/` | 无 |
| [MuntashirAkon/sun-security-android](https://github.com/MuntashirAkon/sun-security-android) | 1.1 | `GPL-2.0-only WITH Classpath-exception-2.0` | 配对/连接用自签 X509 证书 | JitPack AAR | 无 |
| [google/conscrypt](https://github.com/google/conscrypt)（`org.conscrypt:conscrypt-android`） | 2.5.3 | `Apache-2.0` | TLS 1.3 provider | Maven AAR | 无 |
| [apache/commons-compress](https://github.com/apache/commons-compress)（`org.apache.commons:commons-compress`） | 1.27.1 | `Apache-2.0` | `payload.bin` 的 `REPLACE_BZ` 解压 | Maven AAR | 无 |
| [tukaani-project/xz](https://github.com/tukaani-project/xz)（`org.tukaani:xz`） | 1.10 | `0BSD` / Public Domain | `REPLACE_XZ` 解压 | Maven AAR | 无 |

JitPack 仓库声明见 [settings.gradle.kts](android/settings.gradle.kts#L14-L20)，依赖声明见 [build.gradle.kts](android/app/build.gradle.kts#L80-L95)。

## 2. GhostLock — CVE-2026-43499

| 组件 | 版本 | 许可证 | 取用内容 | 落位 | 改动 |
| --- | --- | --- | --- | --- | --- |
| [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app)（native `src/core/`） | `4ebc726` | `Apache-2.0` | futex PI UAF 提权链，78 个 `.c/.cpp/.h/.hpp` 全部哈希一致 | [jni/cve43499](android/app/src/main/jni/cve43499) → `libghostlock.so` | 全部源码未改；新增 `CMakeLists.txt`（把上游 Makefile 构建改为 NDK/CMake 目标） |
| [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app)（`tools/extract_rs`） | `4ebc726` | `Apache-2.0` | 内核偏移提取器，作为 `vrext` 的 Rust 路径依赖 | [jni/ghostlock-app/tools/extract_rs](android/app/src/main/jni/ghostlock-app/tools/extract_rs) | `src/main.rs` 的 CLI 入口按本项目调用方式调整；`src/lib.rs` 未改 |
| [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app)（Kotlin profile 层） | `4ebc726` | `Apache-2.0` | HOCON profile 解析/合并、内置内核表、旧版 `offsets.json` 转换 | `kotlin/.../cve43499/profile/`、`LegacyProfileConverter.kt` | 移植性改写：去除 Compose/Shizuku 依赖，改为本项目数据层与 Pigeon 契约 |

## 3. DirtyFrag — CVE-2026-43284

| 组件 | 版本 | 许可证 | 取用内容 | 落位 | 改动 |
| --- | --- | --- | --- | --- | --- |
| [DONGDERS/DirtyFalg-vr](https://github.com/DONGDERS/DirtyFalg-vr)（`jni/`） | `d4f5c9f`（`v1.16-vr`） | `GPL-2.0-only` | `dfroot` 提权链、8 份预编译 `dfroot-*.ko` | [jni/dfroot](android/app/src/main/jni/dfroot) → `libdfroot.so`、`libbootstrap.so` | `bootstrap.c` 改为本项目包名并适配 NDK；`lkm/dfroot.c` 扩展为当前内核模块实现；`CMakeLists.txt` 重写为 NDK 目标并按本项目包名重编 `.ko`。其余（`exp.c`、`elf_parser.c`、`aes256.h`、`include.inc`、`libcxx.S`、`splicehelper.c`、`lkm/Makefile`）未改 |
| [DONGDERS/DirtyFalg-vr](https://github.com/DONGDERS/DirtyFalg-vr)（`jni/vrext`） | `d4f5c9f` | `GPL-2.0-only` | Rust JNI 包装的偏移提取入口 | [jni/vrext](android/app/src/main/jni/vrext) → `libvrext.so`（进程内 JNI 加载） | `src/lib.rs` 的 JNI 入口按本项目契约调整；`Cargo.toml` 指向本仓库内 `ghostlock-extract`；新增 `src/profile.rs` |
| [YuKongA/payload_extract_rs](https://github.com/YuKongA/payload_extract_rs) | `5534f07` | `GPL-2.0` | `payload.bin` / OTA ZIP 解包 | `vrext` 的 Cargo `git` 依赖，编入 `libvrext.so` | 无（按 git rev 引入，未打补丁） |

## 4. GhostKey — CVE-2026-98260

| 组件 | 版本 | 许可证 | 取用内容 | 落位 | 改动 |
| --- | --- | --- | --- | --- | --- |
| [Again1996-bit/CVE-2026-98260-GhostKey](https://github.com/Again1996-bit/CVE-2026-98260-GhostKey)（native） | `9c216a8` | **上游未提供任何开源许可证** | UAF/creds 提权、KASLR 与 page_offset 校准、rootd/`su`、KernelSU takeover | [jni/cve98260](android/app/src/main/jni/cve98260) → `libcve98260.so` | 12 份 C 源码逐字节未改；新增 `CMakeLists.txt` |
| [Again1996-bit/CVE-2026-98260-GhostKey](https://github.com/Again1996-bit/CVE-2026-98260-GhostKey)（Kotlin） | `9c216a8` | 同上 | `BootImageParser` / `ImgToProfile` / `KallsymsExtractor` | `kotlin/.../cve98260/ota/` | 移植性改写：改为本项目数据层与 Pigeon 契约 |

## 5. 预编译载荷与 KernelSU 交接

| 组件 | 版本 | 许可证 | 取用内容 | 落位 | 改动 |
| --- | --- | --- | --- | --- | --- |
| [hmascs/KSuRoot](https://github.com/hmascs/KSuRoot) | 4.1.2（`aa475cb`） | `Apache-2.0` | 122 份 `libksu_*` 载荷、`libbaseline_6_1/6_12`、`libbs`、`libionstack`、`libcve43499root` | [jniLibs/arm64-v8a](android/app/src/main/jniLibs/arm64-v8a)，127 个文件哈希一致 | 无 |
| [hmascs/KSuRoot](https://github.com/hmascs/KSuRoot)（载荷清单与构建配方） | 4.1.2 | `Apache-2.0` | 清单元数据（`generatedFrom: hmascs/KSuRoot@main`）、基线载荷构建配方 | [payloads/catalog.json](assets/escalation/payloads/catalog.json) | 无 |
| [tiann/KernelSU](https://github.com/tiann/KernelSU) | 未固定 | `GPL-3.0-or-later` | 内嵌 `kernelsu.ko` 的 `ksud`，用于 late-load 内核模块 | `jniLibs/arm64-v8a/libksud.so` | 无（按二进制引入） |

`jniLibs` 共 130 个 `.so`：127 个来自 KSuRoot，其余为 `libksud.so`（本节）与 `libvrext.so`、`libaisup_probe.so`（第 8 节，由本仓库构建）。

## 6. 载荷清单来源

[payloads/catalog.json](assets/escalation/payloads/catalog.json) 共 126 条，全部导入自 KSuRoot（它本身是社区载荷的聚合）。每条在 `source` 字段保留原始出处，合计引用 72 个上游仓库：

| 上游 | 条目数 | 说明 |
| --- | --- | --- |
| [alex193a/Root-My-Pixel](https://github.com/alex193a/Root-My-Pixel) | 29 | Google Pixel 系列 |
| [crabcakes97/GhostLock-Nevada](https://github.com/crabcakes97/GhostLock-Nevada) | 13 | 三星 |
| [xrzcc/s26-m1q-ghostlock-selinux](https://github.com/xrzcc/s26-m1q-ghostlock-selinux) | 5 | 三星 |
| [hmascs/KSuRoot](https://github.com/hmascs/KSuRoot) | 4 | 通用 / 基线 |
| [hackyangwen-lgtm/rmg-s9180-fzg1](https://github.com/hackyangwen-lgtm/rmg-s9180-fzg1) | 3 | 三星 |
| 其余 62 个仓库各 1 条 | 62 | vivo / iQOO、小米、OPPO、realme、通用 |

OTA 清单（[pixel.json](assets/escalation/ota/pixel.json)、[realme.json](assets/escalation/ota/realme.json)）不来自任何上游仓库，由 `build_ota_catalog.py` 从 Google 与 realme 官方 OTA 页面抓取生成。

## 7. 不随包分发的运行时依赖

root 管理器**不链接、不随包**：运行时只扫描设备上已安装管理器的 `libksud.so`，在进程外调用 `ksud`。

| 组件 | 说明 |
| --- | --- |
| [tiann/KernelSU](https://github.com/tiann/KernelSU) | 通用版 |
| [diabl0w/KernelSU](https://github.com/diabl0w/KernelSU) | 三星机型适配 |
| [KernelSU-Next/KernelSU-Next](https://github.com/KernelSU-Next/KernelSU-Next) | KernelSU-Next |
| [KOWX712/KernelSU](https://github.com/KOWX712/KernelSU) | KowSU |
| [Baka-SU/BakaSU](https://github.com/Baka-SU/BakaSU) | BakaSU（原 ReSukiSU） |

## 8. 本项目自行实现

[dugongzi/Aisupass](https://github.com/dugongzi/Aisupass)：`libaisup_probe.so`、`libvrext.so` 的 JNI 入口代码，`jni/CMakeLists.txt`、`jni/cve43499/CMakeLists.txt`、`jni/cve98260/CMakeLists.txt`、`jni/dfroot/CMakeLists.txt`，以及 `lib/`、`kotlin/` 下的业务代码，均为本项目原创，按本项目的 GPL-3.0 分发。

## 9. 继承的致谢

上述链路间接携带的代码：

- DirtyFrag 链路：[mitschud/DirtyFrag](https://github.com/mitschud/DirtyFrag)、[diabl0w/DFRoot](https://github.com/diabl0w/DFRoot)、[lsposed/lspromise](https://github.com/lsposed/lspromise)、[polygraphene/DFReroot](https://github.com/polygraphene/DFReroot)、[combeng6th/DirtyInit](https://github.com/combeng6th/DirtyInit)。
- KSuRoot 基于 [BuSung-dev/Root-My-Galaxy](https://github.com/BuSung-dev/Root-My-Galaxy)；其基线载荷配方源自 [boxiaolanya2008/CVE-2026-43499-Neo11Plus](https://github.com/boxiaolanya2008/CVE-2026-43499-Neo11Plus)。

## 10. 许可证全文

| 许可证 | 文件 | 适用范围 |
| --- | --- | --- |
| GNU GPL v3.0 | [LICENSE](LICENSE) | 本项目自身；同时覆盖 `ksud` 所附 GPL-3.0-or-later |
| GNU GPL v2.0 | [LICENSES/GPL-2.0.txt](LICENSES/GPL-2.0.txt) | DirtyFalg-vr（`jni/dfroot`、`jni/vrext`）与 payload_extract_rs |
| Apache License 2.0 | [LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt) | ghostlock-app、KSuRoot、libadb-android（本项目所选分支）、conscrypt、commons-compress |

各 vendored 目录另附 `NOTICE`，写明来源与改动：`jni/cve43499`、`jni/dfroot`、`jni/vrext`、`jni/cve98260`、`jniLibs/arm64-v8a`。

App 内「设置 → 关于 → 开源协议 / 第三方开源声明」可离线查看上述四份文档。

## 11. 已知风险与待办

以下问题尚未解决，发布前需要处理：

1. **GPL-2.0-only 与 GPL-3.0 的冲突**：`jni/dfroot`、`jni/vrext`（含 `payload_extract_rs`）为 GPL-2.0-only，与本项目的 GPL-3.0 无法直接合并；`libvrext.so` 通过 JNI 在本进程内加载，不能按「独立程序」处理。
2. **`jni/cve98260` 没有任何许可证**：上游仓库无 LICENSE 文件，README 只声明「仅限授权安全研究与自用设备」，未授予再分发权利。当前代码随包分发缺乏授权依据，需向作者取得书面许可或移除该链。
3. **`libksud.so`（GPL-3.0-or-later）的源码提供义务**：需要同时提供对应源码，或在应用内给出有效期为三年的书面提供承诺。
4. **载荷来源未逐一核验**：第 6 节的 126 条载荷来自 72 个上游仓库，仅记录来源，未逐条确认许可证兼容性。
5. **`libadb-android` 的双许可选择**：本项目按 Apache-2.0 使用，需保持该选择在文档中一致；上游同时提示其依赖链内含 LGPL 组件。
