import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_binding.dart';
import 'package:clock_in/pages/today/create_task/create_task_page.dart';
import 'package:clock_in/pages/today/task_list/task_list_binding.dart';
import 'package:clock_in/pages/today/task_list/task_list_page.dart';
import 'package:clock_in/pages/today/today/custom_calendar.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/empty/empty_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        leading: IconButton(
          onPressed: () {
            Get.to(const TaskListPage(), binding: TaskListBinding())
                ?.then((value) {
              controller.loadSelectDayTasks();
            });
          },
          icon: Icon(
            Icons.format_list_bulleted_outlined,
            size: 30.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const CreateTaskPage(), binding: CreateTaskBinding())
                  ?.then((value) {
                controller.loadSelectDayTasks();
              });
            },
            icon: Icon(
              Icons.add,
              size: 30.w,
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Obx(() => CustomCalendar(
                controller.selectedDay.value,
                controller.calendarFirstDay,
                controller.calendarLastDay,
                onDaySelected: (selectedDay, focusDay) {
                  controller.selectedDay.value = selectedDay;
                  controller.loadSelectDayTasks();
                },
                onPageChanged: (selectedDay, focusDay) {
                  controller.selectedDay.value = selectedDay;
                  controller.loadSelectDayTasks();
                },
              )),
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                _taskListView(),
              ],
            ).paddingSymmetric(horizontal: 10.w),
          ))
        ],
      ),
    );
  }

  Widget _taskListView() {
    return Obx(
      () => controller.todayTasks.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _taskItem(controller.todayTasks[index]);
              },
              itemCount: controller.todayTasks.length,
              itemExtent: 100.h,
            )
          : const EmptyChart(
              iconData: Icons.table_view_outlined,
              text: "没有任务哦~",
            ),
    );
  }

  Widget _taskItem(TaskModel taskModel) {
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.success);
        controller.checkTask(taskModel);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: taskModel.color != null
              ? Color(int.parse(taskModel.color!, radix: 16)).withOpacity(0.2)
              : AppColors.primaryBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            if (taskModel.icon != null)
              Image.asset(
                taskModel.icon!,
                width: 40.w,
                height: 40.w,
                fit: BoxFit.contain,
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    taskModel.taskName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.mainTitle333,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (taskModel.slogan?.isNotEmpty == true)
                    Row(
                      children: [
                        Expanded(
                            child: AutoSizeText(
                          taskModel.slogan!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.subtitle666,
                            fontSize: 14.sp,
                          ),
                        ))
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            _checkBox(taskModel),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _checkBox(TaskModel taskModel) {
    final todayTaskModel = taskModel.recordsData?.firstWhere(
        (element) =>
            element.date == controller.selectedDay.toString().split(' ')[0],
        orElse: () => CheckRecordModel());
    return GestureDetector(
      onTap: () {
        Vibrate.feedback(FeedbackType.success);
        controller.checkTask(taskModel);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 36.w,
        height: 36.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: taskModel.checkCount == todayTaskModel?.checkCount
            ? Icon(
                taskModel.checkCount! > 0
                    ? Icons.check
                    : Icons.check_box_outline_blank,
                color: Color(int.parse(taskModel.color!, radix: 16))
                    .withOpacity(1),
                size: 28.w,
              ).animate().scale(
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceInOut)
            : AutoSizeText(
                todayTaskModel?.checkCount == 0
                    ? ""
                    : "${todayTaskModel?.checkCount}/${taskModel.checkCount}",
                maxLines: 1,
                style: TextStyle(
                    color: Color(int.parse(taskModel.color!, radix: 16))
                        .withOpacity(1),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
