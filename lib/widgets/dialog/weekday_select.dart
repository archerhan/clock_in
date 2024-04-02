import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class WeekdaySelectDialog {
  static final weekdays = [
    WeekdayModel(1, "周一"),
    WeekdayModel(2, "周二"),
    WeekdayModel(3, "周三"),
    WeekdayModel(4, "周四"),
    WeekdayModel(5, "周五"),
    WeekdayModel(6, "周六"),
    WeekdayModel(7, "周日"),
  ];
  static void showMultiSelect(
      BuildContext context, Function(List<int>) onConfirm,
      {List<int>? initSelectedValues}) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r)),
          ),
          child: MultiSelectBottomSheet<int>(
            items: weekdays.map((e) {
              return MultiSelectItem(e.value, e.name);
            }).toList(),
            title: Expanded(
                child: Text(
              "选择重复日期",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            )),
            confirmText: Text(
              "确定",
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            cancelText: Text(
              "取消",
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            selectedItemsTextStyle: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            itemsTextStyle: TextStyle(
                color: AppColors.subtitle666,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
            listType: MultiSelectListType.CHIP,
            initialValue: initSelectedValues ?? [],
            onConfirm: (values) {
              values.sort((a, b) => a.compareTo(b));
              onConfirm(values);
            },
            maxChildSize: 0.8,
          ),
        );
      },
    );
  }
}

class WeekdayModel {
  final int value;
  final String name;

  WeekdayModel(this.value, this.name);
}
