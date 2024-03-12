// ignore_for_file: file_names

import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OKButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  const OKButton({required this.title, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.mainWhite,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ))
          ],
        ),
      ),
    );
  }
}
