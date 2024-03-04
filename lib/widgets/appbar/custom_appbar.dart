// 自定义AppBar
import 'package:flutter/material.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    super.title,
    super.actions,
    super.leading,
    super.bottom,
    super.elevation,
    super.shadowColor,
    super.shape,
    super.backgroundColor,
    Brightness? brightness,
    super.iconTheme,
    super.actionsIconTheme,
    TextTheme? textTheme,
    super.primary,
    bool super.centerTitle = true,
    super.excludeHeaderSemantics,
    double super.titleSpacing = NavigationToolbar.kMiddleSpacing,
    super.toolbarOpacity,
    super.bottomOpacity,
  });
}