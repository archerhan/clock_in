import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalDivider extends Divider {
  const HorizontalDivider({super.key})
      : super(
          indent: 0,
          endIndent: 0,
          thickness: 1,
          height: 1,
          color: AppColors.dividerEEE,
        );
}
