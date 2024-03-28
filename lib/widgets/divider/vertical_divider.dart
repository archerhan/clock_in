import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomVerticalDivider extends VerticalDivider {
  const CustomVerticalDivider({super.key})
      : super(
          indent: 0,
          endIndent: 0,
          thickness: 1,
          width: 1,
          color: AppColors.dividerEEE,
        );
}
