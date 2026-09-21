import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/utils/color_util.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ColorPicker {
  static void showColorPicker(
      BuildContext context, Function(String) onConfirm) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 256.h,
          // margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          padding: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
              color: AppColors.mainWhite,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ]),
          child: Column(
            children: [
              Text(
                "请选择背景颜色",
                style: TextStyle(
                    color: AppColors.subtitle666,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              const HorizontalDivider(),
              MediaQuery.removePadding(
                removeBottom: true,
                removeTop: true,
                context: context,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6),
                  itemBuilder: (_, index) {
                    final color = Colors.primaries[index];
                    final colorValue = ColorUtil.toHex(color);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        onConfirm(colorValue);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Colors.transparent),
                        child: CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  },
                  itemCount: Colors.primaries.length,
                ).paddingSymmetric(horizontal: 20.w),
              )
            ],
          ).paddingSymmetric(vertical: 10.h),
        );
      },
    );
  }
}
