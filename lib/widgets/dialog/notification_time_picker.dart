import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:tuple/tuple.dart';

class NotificationTimePickerDialog {
  // 通知时间
  static const notificationTuples = <Tuple2>[
    Tuple2(0, "每天"),
    Tuple2(1, "周一"),
    Tuple2(2, "周二"),
    Tuple2(3, "周三"),
    Tuple2(4, "周四"),
    Tuple2(5, "周五"),
    Tuple2(6, "周六"),
    Tuple2(7, "周日"),
  ];
  // 周一到周日, 0为每天
  static final notificationDays = [
    ["每天", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
    List.generate(24, (index) => (index).toString().padLeft(2, "0")),
    List.generate(60, (index) => (index).toString().padLeft(2, "0"))
  ];

  static void showNotificationDayDialog(
      BuildContext context, Function(String?) onConfirm,
      {String? selected}) {
    var picker = Picker(
        height: 200.h,
        itemExtent: 32.h,
        backgroundColor: Colors.transparent,
        headerDecoration: BoxDecoration(
            color: AppColors.mainWhite,
            border: const Border(
                bottom: BorderSide(color: AppColors.dividerEEE, width: 1)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r))),
        adapter: PickerDataAdapter(
          pickerData: notificationDays,
          isArray: true,
        ),
        selecteds: selected == null ? [0, 7, 30] : getSelectedList(selected),
        title: Text(
          "请选择提醒时间",
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
          final selectedList = picker.getSelectedValues();
          final day = notificationTuples
              .firstWhere((element) => element.item2 == selectedList[0])
              .item1;
          final value =
              "$day-${selectedList[1].toString().padLeft(2, "0")}:${selectedList[2].toString().padLeft(2, "0")}";
          onConfirm(value);
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

  static List<int> getSelectedList(String selectedString) {
    final selectedList = selectedString.split("-");
    final day = int.parse(selectedList[0]);
    final time = selectedList[1].split(":");
    final hour = int.parse(time[0]);
    final minute = int.parse(time[1]);
    return [day, hour, minute];
  }
}
