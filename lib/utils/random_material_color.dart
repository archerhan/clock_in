// 获取随机Material Color
import 'dart:math';
import 'package:flutter/material.dart';

class RandomMaterialColor {
  // 获取随机Material Color色值
  static String getRandomColorValue() {
    final randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];
    final colorValue = randomColor.value.toRadixString(16).substring(2);
    return colorValue;
  }
}
