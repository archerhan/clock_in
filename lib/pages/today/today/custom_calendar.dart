import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends GetView<TodayController> {
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
      rowHeight: 64.h,
      headerVisible: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.twoWeeks,
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
          constraints: const BoxConstraints.expand(),
          margin: const EdgeInsets.all(5),
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
          child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    day.day == 1 ? _monthName(day.month) : day.day.toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: DateTime(day.year, day.month, day.day).isAfter(
                        DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day),
                      )
                          ? AppColors.grey999
                          : AppColors.subtitle666,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // 判断日期是否包含在dailyCheckCountData中
                  (controller.dailyCheckCountData
                              .containsKey(day.toString().split(" ").first) &&
                          controller.dailyCheckCountData[
                                  day.toString().split(" ").first]! >
                              0)
                      ? Icon(
                          Icons.check,
                          size: 12.w,
                          color: AppColors.textGreen,
                        )
                      : SizedBox(
                          width: 12.w,
                          height: 12.w,
                        ),
                ],
              )),
        );
      },
    );
  }

  String _monthName(int month) {
    var array = [
      '一月'.tr,
      '二月'.tr,
      '三月'.tr,
      '四月'.tr,
      '五月'.tr,
      '六月'.tr,
      '七月'.tr,
      '八月'.tr,
      '九月'.tr,
      '十月'.tr,
      '十一月'.tr,
      '十二月'.tr,
    ];
    return array[month - 1];
  }
}
