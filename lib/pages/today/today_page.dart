import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/calendar/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/today/today_controller.dart';

class TodayPage extends GetView<TodayController> {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("懒猫打卡".tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CustomCalendar(controller.today, controller.calendarFirstDay,
                controller.calendarLastDay)
          ],
        ).paddingSymmetric(horizontal: 10.w),
      ),
    );
  }

//   Widget _taskListView() {
// return ListView.builder(itemBuilder: itemBuilder, itemCount: itemCount,) ;

//   }
}
