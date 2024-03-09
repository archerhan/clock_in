import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 2.w,
          height: 20.w,
          decoration: const BoxDecoration(
              color: AppColors.primaryYellow, shape: BoxShape.rectangle),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
              color: AppColors.mainTitle333,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
        ),
      ],
    ).paddingSymmetric(vertical: 10);
  }
}
