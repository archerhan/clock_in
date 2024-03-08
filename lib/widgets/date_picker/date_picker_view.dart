// ignore_for_file: must_be_immutable, constant_identifier_names

import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/widgets/date_picker/date_picker_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

enum DatePickerShowType { ymd, ym }

class DatePickerView extends GetView<DatePickerController> {
  DatePickerShowType? showType;

  DatePickerView({this.showType = DatePickerShowType.ymd, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildYear(),
            Text(
              '年',
              style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.mainTitle333,
                  fontWeight: FontWeight.w500),
            ),
            _buildMonth(),
            Text(
              '月',
              style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.mainTitle333,
                  fontWeight: FontWeight.w500),
            ),
            if (showType == DatePickerShowType.ymd) _buildDay(),
            if (showType == DatePickerShowType.ymd)
              Text(
                '日',
                style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColors.mainTitle333,
                    fontWeight: FontWeight.w500),
              ),
          ],
        )),
      ],
    );
  }

  Widget _buildYear() {
    return _pickerItem(
        controller.years.map((e) {
          return SizedBox(
            width: 80.w,
            child: Center(
                child: Text(
              e,
              style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.mainTitle333,
                  fontWeight: FontWeight.w500),
            )),
          );
        }).toList(), (index) {
      controller.selectYear = controller.years[index].toString();
      controller.setDays(
          int.parse(controller.selectYear), int.parse(controller.selectMonth));
    },
        initialIndex: controller.years
            .indexWhere((element) => element == controller.selectYear));
  }

  Widget _buildMonth() {
    return _pickerItem(
        controller.months.map((e) {
          return SizedBox(
            width: 40.w,
            child: Center(
                child: Text(
              e,
              style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.mainTitle333,
                  fontWeight: FontWeight.w500),
            )),
          );
        }).toList(), (index) {
      controller.selectMonth = controller.months[index].toString();
      controller.setDays(
          int.parse(controller.selectYear), int.parse(controller.selectMonth));
      controller.updateYear(index);
    },
        initialIndex: controller.months
            .indexWhere((element) => element == controller.selectMonth));
  }

  Widget _buildDay() {
    return Obx(() => _pickerItem(
            controller.days.map((e) {
              return SizedBox(
                width: 40.w,
                child: Center(
                    child: Text(
                  e,
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.mainTitle333,
                      fontWeight: FontWeight.w500),
                )),
              );
            }).toList(), (index) {
          controller.selectDay = controller.days[index].toString();
        },
            initialIndex: controller.days
                .indexWhere((element) => element == controller.selectDay)));
  }

  Widget _pickerItem(List<Widget> children, Function(int) onItemSelected,
      {int initialIndex = 0}) {
    var controller = FixedExtentScrollController(initialItem: initialIndex);
    return Container(
      color: Colors.transparent,
      width: 80.w,
      child: CupertinoPicker(
        useMagnifier: true,
        itemExtent: 40.h,
        scrollController: controller,
        looping: true,
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: AppColors.primaryBlue.withOpacity(0.15),
        ),
        diameterRatio: 0.8,
        squeeze: 1.4,
        // offAxisFraction: -0.4,
        onSelectedItemChanged: onItemSelected,
        children: children,
      ),
    );
  }
}
