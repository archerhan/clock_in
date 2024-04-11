// 自定义AppBar
import 'package:clock_in/constants/app_colors.dart';
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
    super.backgroundColor = AppColors.primaryYellow,
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