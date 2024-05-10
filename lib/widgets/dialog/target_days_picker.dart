import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class TargetDaysPickerDialog {
  static List<int> days = [
    365,
    90,
    60,
    30,
    21,
    10,
    7,
    ...List<int>.generate(100, (index) => index + 1)
  ];

  /// 圆角背景
  static void showDaysPicker(BuildContext context, Function(int?) onConfirm,
      {int? selected}) {
    var picker = Picker(
        itemExtent: 32.h,
        height: 200.h,
        backgroundColor: Colors.transparent,
        headerDecoration: BoxDecoration(
            color: AppColors.mainWhite,
            border: const Border(
                bottom: BorderSide(color: AppColors.dividerEEE, width: 1)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r))),
        adapter: PickerDataAdapter(
          data: days.map((e) {
            return PickerItem(
                text: Text(
                  e == 0 ? "永远" : "$e天",
                  style: TextStyle(
                      color: AppColors.grey999,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600),
                ),
                value: e);
          }).toList(),
        ),
        selecteds: selected != null ? [days.indexOf(selected)] : [7],
        title: Text(
          "请选择目标达成所需天数",
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
          onConfirm(days[value.first]);
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
          child: Container(
            child: view,
          ));
    });
  }
}
