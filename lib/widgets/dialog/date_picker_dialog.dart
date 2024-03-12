import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

class CustomDatePickerDialog {
  /// 圆角背景
  static void showDatePicker(
      BuildContext context, Function(DateTime?) onConfirm) {
    var picker = Picker(
        height: 200.h,
        backgroundColor: Colors.transparent,
        headerDecoration: BoxDecoration(
            color: AppColors.mainWhite,
            border: const Border(
                bottom: BorderSide(color: AppColors.dividerEEE, width: 1)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r))),
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMD,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日"),
        title: Text(
          "请选择日期",
          style: TextStyle(
              color: AppColors.subtitle666,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold),
        ),
        confirmText: "确定",
        cancelText: "取消",
        textStyle: TextStyle(
            color: AppColors.mainTitle333,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500),
        onConfirm: (Picker picker, List value) {
          onConfirm((picker.adapter as DateTimePickerAdapter).value);
        },
        onSelect: (Picker picker, int index, List<int> selected) {
          Vibrate.feedback(FeedbackType.selection);
        });
    picker.showModal(context, backgroundColor: Colors.transparent,
        builder: (context, view) {
      return Material(
          // color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
          child: view);
    });
  }
}
