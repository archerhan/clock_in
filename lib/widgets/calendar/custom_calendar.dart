import 'package:clock_in/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;

  const CustomCalendar(this.focusedDay, this.firstDay, this.lastDay,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      pageJumpingEnabled: true,
      headerVisible: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.twoWeeks,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: _weekStyle(),
      daysOfWeekHeight: 28.h,
      calendarBuilders: _calendarBuilders(),
      onDaySelected: (selectedDay, focusedDay) {
        Get.snackbar('Selected Day', selectedDay.toString());
      },
    );
  }

  DaysOfWeekStyle _weekStyle() {
    return DaysOfWeekStyle(
        dowTextFormatter: (date, locale) {
          var array = [
            'Mon'.tr,
            'Tues'.tr,
            'Wed'.tr,
            'Thurs'.tr,
            'Fri'.tr,
            'Sat'.tr,
            'Sun'.tr,
          ];
          return array[date.weekday - 1];
        },
        weekendStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.subtitle666,
            fontWeight: FontWeight.bold),
        weekdayStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.subtitle666,
            fontWeight: FontWeight.bold));
  }

  CalendarBuilders _calendarBuilders() {
    return CalendarBuilders(
      prioritizedBuilder: (context, day, focusDay) {
        return Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color:
                day.day % 2 == 0 ? AppColors.bgColor : AppColors.primaryYellow,
            shape: BoxShape.rectangle,
            border: Border.all(color: AppColors.primaryYellow, width: 4),
          ),
          child: Center(
            child: Text(
              day.day == 1 ? _monthName(day.month) : day.day.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.subtitle666,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    var array = [
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr,
    ];
    return array[month - 1];
  }
}
