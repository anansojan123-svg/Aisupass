/// 应用自身的开源信息。
class AppLinks {
  AppLinks._();

  /// 官网地址。
  static const String website = 'https://aisupass.org';

  /// 官网地址的展示文本。
  static const String websiteDisplay = 'aisupass.org';

  /// 源码仓库地址。
  static const String repository = 'https://github.com/dugongzi/Aisupass';

  /// 仓库地址的展示文本，设置页副标题用。
  static const String repositoryDisplay = 'github.com/dugongzi/Aisupass';

  /// 新建 Issue 页面地址，功能许愿入口用。
  static const String newIssue = '$repository/issues/new';

  /// 设置页「官网」行的图标：应用自身图标（彩色，无模糊滤镜版本）。
  static const String appIconAsset = 'assets/images/branding/app_icon_flat.svg';

  /// 设置页「开源地址」行的图标：GitHub 标记。
  static const String githubIconAsset = 'assets/images/icons/github.svg';

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
