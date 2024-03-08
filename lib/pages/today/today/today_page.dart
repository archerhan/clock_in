import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_binding.dart';
import 'package:clock_in/pages/today/create_task/create_task_page.dart';
import 'package:clock_in/pages/today/today/task_record_model.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/calendar/custom_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';

class TodayPage extends GetView<TodayController> {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("懒猫打卡".tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const CreateTaskPage(), binding: CreateTaskBinding());
            },
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            CustomCalendar(controller.today, controller.calendarFirstDay,
                controller.calendarLastDay),
            const SizedBox(height: 10),
            _taskListView()
          ],
        ).paddingSymmetric(horizontal: 10.w),
      ),
    );
  }

  Widget _taskListView() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _taskItem(controller.taskRecords[index]);
        },
        itemCount: controller.taskRecords.length,
        itemExtent: 100.h,
      ),
    );
  }

  Widget _taskItem(TaskRecordModel taskRecordModel) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.medium);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: taskRecordModel.color != null
              ? Color(int.parse(taskRecordModel.color!, radix: 16))
                  .withOpacity(0.2)
              : AppColors.primaryBlue.withOpacity(0.2),
          // boxShadow: [
          //   BoxShadow(
          //       color: randomColor.withOpacity(0.2),
          //       blurRadius: 5.r,
          //       offset: const Offset(3, 3),
          //       spreadRadius: 1.r)
          // ],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            if (taskRecordModel.icon != null)
              Image.asset(
                taskRecordModel.icon!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskRecordModel.taskName ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.mainTitle333,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  taskRecordModel.slogan ?? "",
                  style: TextStyle(
                    color: AppColors.subtitle666,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _checkBox(taskRecordModel),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _checkBox(TaskRecordModel taskRecordModel) {
    return GestureDetector(
      onTap: () {
        controller.onTaskItemTapped(taskRecordModel);
        Vibrate.feedback(FeedbackType.medium);
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: taskRecordModel.checkCount == taskRecordModel.totalCheckCount
            ? Icon(
                taskRecordModel.checkCount! > 0
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                color: Colors.white,
              )
            : Text(
                taskRecordModel.checkCount == 0
                    ? ""
                    : "${taskRecordModel.checkCount}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
