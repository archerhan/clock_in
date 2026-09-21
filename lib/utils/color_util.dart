import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 颜色与十六进制字符串之间的转换工具。
///
/// 数据库里保存的颜色形如 `f44336`(不带 alpha)或 `fff44336`(带 alpha),
/// 旧代码直接用 `Color(int.parse(value, radix: 16))` 读取, 6 位色值会被解析成
/// alpha=0 的完全透明颜色, 导致任务卡片/图标不可见。
class ColorUtil {
  ColorUtil._();

  /// 将十六进制色值字符串转换为 [Color], 非法值返回 [fallback]。
  static Color fromHex(String? hex, {Color fallback = AppColors.primaryBlue}) {
    if (hex == null || hex.isEmpty) {
      return fallback;
    }
    var value = hex.trim().replaceFirst('#', '').replaceFirst('0x', '');
    // 6 位色值缺少 alpha, 补上不透明通道
    if (value.length == 6) {
      value = 'ff$value';
    }
    if (value.length != 8) {
      return fallback;
    }
    final parsed = int.tryParse(value, radix: 16);
    return parsed == null ? fallback : Color(parsed);
  }

  /// 将 [color] 转换为不带 alpha 的 6 位十六进制色值, 用于写入数据库。
  static String toHex(Color color, {bool withAlpha = false}) {
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return withAlpha ? argb : argb.substring(2);
  }
}
