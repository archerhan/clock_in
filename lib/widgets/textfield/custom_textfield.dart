import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends TextField {
  CustomTextField({
    super.key,
    required TextEditingController super.controller,
    String? hintText,
    TextStyle? textStyle,
    TextAlign? textAlign,
  }) : super(
          style: textStyle ??
              TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            hintStyle: TextStyle(
                color: AppColors.grey999,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            hintText: hintText,
            border: InputBorder.none,
          ),
        );
}
