// 获取随机Material Color
import 'dart:math';

import 'package:clock_in/utils/color_util.dart';
import 'package:flutter/material.dart';

class RandomMaterialColor {
  // 获取随机Material Color色值
  static String getRandomColorValue() {
    final randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    return ColorUtil.toHex(randomColor);
  }
}
