import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CustomNumberPickerDialog {
  static List<int> hours = List<int>.generate(24, (index) => index + 1);

  /// 圆角背景
  static void showCheckCountPicker(
      BuildContext context, Function(int?) onConfirm) {
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
        adapter: PickerDataAdapter(
          data: hours.map((e) {
            return PickerItem(
                text: Text(
                  "$e次",
                  style: TextStyle(
                      color: AppColors.grey999,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600),
                ),
                value: e);
          }).toList(),
        ),
        selecteds: [0],
        title: Text(
          "请选择每天的打卡次数",
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
          onConfirm(hours[value.first]);
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
