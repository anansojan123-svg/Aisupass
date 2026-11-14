import 'package:Aisupass/generated/cve98260.g.dart';
import 'package:Aisupass/generated/dirty_frag.g.dart';
import 'package:Aisupass/generated/ghost_lock.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'escalation_native_provider.g.dart';

/// DirtyFrag 运行的原生接口实例。
@riverpod
DirtyFragNative dirtyFragNative(Ref ref) => DirtyFragNative();

/// CVE-98260（GhostKey）运行的原生接口实例。
@riverpod
Cve98260Native cve98260Native(Ref ref) => Cve98260Native();

/// GhostLock 运行的原生接口实例。
@riverpod
GhostLockNative ghostLockNative(Ref ref) => GhostLockNative();

/// GhostLock profile 导入的原生接口实例。
@riverpod
GhostLockProfileNative ghostLockProfileNative(Ref ref) =>
    GhostLockProfileNative();

/// GhostLock profile 编辑的原生接口实例。
@riverpod
GhostLockProfileEditNative ghostLockProfileEditNative(Ref ref) =>
    GhostLockProfileEditNative();

/// 用户 profile（GhostKey / GhostLock 共用）的原生接口实例。
@riverpod
Cve98260ProfileNative cve98260ProfileNative(Ref ref) => Cve98260ProfileNative();

/// 运行日志的原生接口实例。
@riverpod
Cve98260RunLogNative cve98260RunLogNative(Ref ref) => Cve98260RunLogNative();
