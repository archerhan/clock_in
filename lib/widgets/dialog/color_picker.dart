import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorPicker {
  static void showColorPicker(
      BuildContext context, Function(String) onConfirm) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          padding: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
              color: AppColors.mainWhite,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ]),
          child: MediaQuery.removePadding(
            removeBottom: true,
            removeTop: true,
            context: context,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6),
              itemBuilder: (_, index) {
                final colorValue = Colors.primaries[index].value
                    .toRadixString(16)
                    .substring(2);
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onConfirm(colorValue);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                    child: CircleAvatar(
                      backgroundColor: Colors.primaries[index].withOpacity(0.3),
                    ),
                  ),
                );
              },
              itemCount: Colors.primaries.length,
            ),
          ),
        );
      },
    );
  }
}
