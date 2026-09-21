# clock_in
打卡、习惯养成

一个用 Flutter 写的打卡 / 习惯养成 App: 任务打卡、连续天数统计、打卡热力图、
任务奖励、iCloud 备份与本地通知。

## 本地运行（iOS）

```bash
flutter pub get
flutter run -d "iPhone 17"    # 或任意已启动的模拟器 / 真机
```

### 演示数据

debug 构建在数据库为空时会自动写入一批演示数据(7 个任务 + 打卡记录 + 奖励),
方便直接看首页 / 统计 / 奖励页的效果。release 构建默认不写入, 需要时:

```bash
flutter run --release --dart-define=SEED_DEMO_DATA=true
```

相关代码在 `lib/manager/demo_data_manager.dart`。

### 换成自己的配置

开源版本里的以下标识都是占位符, 二次开发时需要替换成你自己的:

| 位置 | 说明 |
| --- | --- |
| `ios/Runner.xcodeproj/project.pbxproj` | `PRODUCT_BUNDLE_IDENTIFIER`(默认 `com.example.clockin`); 真机运行还需要补上 `DEVELOPMENT_TEAM` |
| `ios/Runner/Runner.entitlements` | iCloud 容器 `iCloud.com.example.clockin` |
| `android/app/build.gradle` | `applicationId` |
| `lib/constants/app_strings.dart` | 官网、反馈邮箱、社交账号、内购商品 ID、iCloud 容器 ID |
| `lib/constants/privacy.dart` | 隐私政策 / 用户协议里的联系方式 |

### 第三方插件补丁

`third_party/` 下是从 pub 缓存复制并打补丁的两个插件，通过 `dependency_overrides`
指向本地路径：

- `flutter_vibrate`
  - 原版 1.4.0 在 Xcode 26 下编译失败（Swift 里没有 `TARGET_OS_SIMULATOR`），改为
    `#if targetEnvironment(simulator)`。
- `flutter_picker`
  - 原版 2.1.0 使用了新版 Flutter 已移除的 API（`ThemeData.bottomAppBarColor`、
    `TextTheme.headline6`），替换为 `bottomAppBarTheme.color` / `titleLarge`。

上游修复后可以删掉 `dependency_overrides` 并移除 `third_party/`。
