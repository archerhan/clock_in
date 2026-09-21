# clock_in
打卡、习惯养成

## 本地运行（iOS）

```bash
flutter pub get
flutter run -d "iPhone 17"    # 或任意已启动的模拟器 / 真机
```

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
