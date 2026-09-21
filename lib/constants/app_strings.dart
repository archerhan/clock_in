class AppStrings {
  AppStrings._();

  // TODO(开源使用): 换成你自己的官网 / 反馈邮箱 / 社交账号
  static const website = "https://example.com";
  static const feedbackEmailAddress = "feedback@example.com";
  static const zhihuLink = "https://www.zhihu.com/";
  static const weiboLink = "https://weibo.com/";
  static const xiaohongshuLink = "https://www.xiaohongshu.com/";

  // 内购商品 ID, 需要与 App Store Connect / Google Play 后台配置一致
  static const productKey = "clock_in_premium";

  // iCloud 容器 ID, 需要与 apple 开发者后台 + entitlements 保持一致
  static const iCloudContainerId = "iCloud.com.example.clockin";

  // save keys
  static const String autoSyncDataKey = "autoSyncDataKey";
  static const String allowNotificationKey = "allowNotificationKey";
  static const String isAgreePrivacyLey = "isAgreePrivacyLey";
  static const String hasPurchasedKey = "hasPurchasedKey";
}
