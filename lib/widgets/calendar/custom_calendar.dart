import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final Function(DateTime selectedDay, DateTime focusDay)? onDaySelected;
  final Function(DateTime selectedDay, DateTime focusDay)? onPageChanged;

  const CustomCalendar(this.focusedDay, this.firstDay, this.lastDay,
      {super.key, this.onDaySelected, this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: lastDay,
      pageJumpingEnabled: true,
      headerVisible: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      daysOfWeekStyle: _weekStyle(),
      daysOfWeekHeight: 28.h,
      calendarBuilders: _calendarBuilders(),
      onDaySelected: (selectedDay, focusDay) {
        onDaySelected?.call(selectedDay, focusDay);
      },
      onDisabledDayTapped: (day) {
        Vibrate.feedback(FeedbackType.error);
      },
      onPageChanged: (focusedDay) {
        if (onDaySelected != null) {
          onDaySelected!(focusedDay, focusedDay);
        }
        onPageChanged?.call(focusedDay, focusedDay);
      },
    );
  }

  DaysOfWeekStyle _weekStyle() {
    return DaysOfWeekStyle(
        dowTextFormatter: (date, locale) {
          var array = [
            '周一'.tr,
            '周二'.tr,
            '周三'.tr,
            '周四'.tr,
            '周五'.tr,
            '周六'.tr,
            '周日'.tr,
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
            color: AppColors.bgColor,
            shape: BoxShape.rectangle,
            border: Border.all(
                color: (DateTimeUtil.isToday(day) ||
                        day.year == focusedDay.year &&
                            day.month == focusedDay.month &&
                            day.day == focusedDay.day)
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                width: 4),
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
