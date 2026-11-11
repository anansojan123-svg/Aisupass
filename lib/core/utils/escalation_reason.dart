import 'package:Aisupass/l10n/app_localizations.dart';

/// 原生侧会回的原因码。
///
/// 只翻译这几个；其余串是原生抛上来的原始错误，按原样贴出来更有用。
const Set<String> kEscalationReasonCodes = <String>{
  'emptyCommand',
  'channelNotReady',
  'streamOpenFailed',
};

String escalationReasonLabel(String code, AppLocalizations l10n) =>
    switch (code) {
      'emptyCommand' => l10n.escalationExecReasonEmpty,
      'channelNotReady' => l10n.escalationExecReasonNotReady,
      'streamOpenFailed' => l10n.escalationExecReasonStreamFailed,
      // 未识别的原因也比「命令没能启动：」后面空着强。
      _ => code,
    };

/// 退出码行。负数是「没取到」，不是真实退出码。
String escalationExitTag(int code) => code < 0 ? 'exit --' : 'exit $code';

/// GhostKey 拒绝受理的原因码 → 「文案（码）」；未识别的码原样返回。
String ghostKeyNotStartedReason(AppLocalizations l10n, String code) =>
    _withCode(l10n, code, switch (code) {
      'alreadyRunning' => l10n.escalationGhostKeyReasonAlreadyRunning,
      'noAdb' => l10n.escalationGhostKeyReasonNoAdb,
      'notShell' => l10n.escalationGhostKeyReasonNotShell,
      'seccompFiltered' => l10n.escalationGhostKeyReasonSeccomp,
      'missingBinary' => l10n.escalationGhostKeyReasonMissingBinary,
      'noProfile' => l10n.escalationGhostKeyReasonNoProfile,
      'badRequest' => l10n.escalationGhostKeyReasonBadRequest,
      _ => null,
    });

/// DirtyFrag 拒绝受理的原因码 → 「文案（码）」；未识别的码原样返回。
String dirtyFragNotStartedReason(AppLocalizations l10n, String code) =>
    _withCode(l10n, code, switch (code) {
      'alreadyArmed' => l10n.escalationDirtyFragReasonAlreadyArmed,
      'busy' => l10n.escalationDirtyFragReasonBusy,
      'noIpSec' => l10n.escalationDirtyFragReasonNoIpSec,
      'missingBinary' => l10n.escalationDirtyFragReasonMissingBinary,
      'stagingFailed' => l10n.escalationDirtyFragReasonStagingFailed,
      'badRequest' => l10n.escalationDirtyFragReasonBadRequest,
      _ => null,
    });

/// 码留在文案后面，出问题时还能对照原生日志。
String _withCode(AppLocalizations l10n, String code, String? label) =>
    label == null ? code : l10n.escalationReasonWithCode(label, code);
