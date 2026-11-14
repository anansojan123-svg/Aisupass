/// 应用自身的开源信息。
class AppLinks {
  AppLinks._();

  /// 源码仓库地址。
  static const String repository = 'https://github.com/dugongzi/Aisupass';

  /// 仓库地址的展示文本，设置页副标题用。
  static const String repositoryDisplay = 'github.com/dugongzi/Aisupass';

  /// 协议页可切换的文档；顺序与切换条一致，全部随包分发。
  static const List<String> licenseDocAssets = <String>[
    'LICENSE',
    'THIRD_PARTY_NOTICES.md',
    'LICENSES/Apache-2.0.txt',
    'LICENSES/GPL-2.0.txt',
  ];

  /// 第三方声明在 [licenseDocAssets] 中的下标。
  static const int thirdPartyNoticesDocIndex = 1;
}
