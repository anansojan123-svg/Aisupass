import 'package:Aisupass/features/escalation/domain/enums/ghost_key_stage.dart';
import 'package:Aisupass/l10n/app_localizations.dart';

// GhostKey 五阶段的展示映射：阶段名与进行中提示，全部走 l10n。

/// 阶段名。
String ghostKeyStageName(AppLocalizations l10n, GhostKeyStage stage) =>
    switch (stage) {
      GhostKeyStage.calibA => l10n.escalationGhostKeyStageCalibAName,
      GhostKeyStage.calibB => l10n.escalationGhostKeyStageCalibBName,
      GhostKeyStage.inject => l10n.escalationGhostKeyStageInjectName,
      GhostKeyStage.verify => l10n.escalationGhostKeyStageVerifyName,
      GhostKeyStage.ksu => l10n.escalationGhostKeyStageKsuName,
    };

/// 阶段进行中提示（承接上游 `ENTER_HINT`）。
String ghostKeyStageHint(AppLocalizations l10n, GhostKeyStage stage) =>
    switch (stage) {
      GhostKeyStage.calibA => l10n.escalationGhostKeyStageCalibAHint,
      GhostKeyStage.calibB => l10n.escalationGhostKeyStageCalibBHint,
      GhostKeyStage.inject => l10n.escalationGhostKeyStageInjectHint,
      GhostKeyStage.verify => l10n.escalationGhostKeyStageVerifyHint,
      GhostKeyStage.ksu => l10n.escalationGhostKeyStageKsuHint,
    };
