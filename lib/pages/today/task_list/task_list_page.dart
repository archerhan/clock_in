import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_binding.dart';
import 'package:clock_in/pages/today/create_task/create_task_page.dart';
import 'package:clock_in/pages/today/task_list/task_list_controller.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:clock_in/widgets/empty/empty_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'package:get/get.dart';

class TaskListPage extends GetView<TaskListController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("全部任务"),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const CreateTaskPage(), binding: CreateTaskBinding())
                  ?.then((value) {
                controller.loadAllTask();
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
        children: [Expanded(child: _taskList())],
      ),
    );
  }

  Widget _taskList() {
    return Obx(() => controller.taskList.isNotEmpty
        ? ReorderableListView.builder(
            shrinkWrap: true,
            itemCount: controller.taskList.length,
            onReorder: (oldIndex, newIndex) {
              Vibrate.feedback(FeedbackType.success);
              controller.reorder(oldIndex, newIndex);
            },
            itemBuilder: (BuildContext context, int index) {
              return _taskItem(controller.taskList[index], onTap: () {
                logger.d("点击了任务:${controller.taskList[index].taskName}");
                Get.to(const CreateTaskPage(),
                    arguments: controller.taskList[index],
                    binding: CreateTaskBinding());
              });
            },
          )
        : const EmptyChart(
            iconData: Icons.table_view_outlined,
            text: "去创建一个任务吧~",
          ));
  }

  Widget _taskItem(TaskModel taskModel, {Function? onTap}) {
    return GestureDetector(
      // key 为recorderList的唯一标识
      key: Key(taskModel.id.toString()),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ]),
        margin:
            EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r)),
                color: taskModel.isActive == 1
                    ? (taskModel.color != null
                        ? Color(int.parse(taskModel.color!, radix: 16))
                            .withOpacity(1)
                        : AppColors.primaryBlue.withOpacity(1))
                    : Colors.grey,
              ),
              child: Row(
                children: [
                  Image.asset(taskModel.icon!,
                      width: 38.w, height: 38.w, fit: BoxFit.contain),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          taskModel.taskName ?? "",
                          style: TextStyle(
                              color: AppColors.mainWhite,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          taskModel.slogan ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.dividerEEE,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    value: taskModel.isActive == 1,
                    onChanged: (value) {
                      Vibrate.feedback(FeedbackType.medium);
                      final task = taskModel;
                      task.isActive = value ? 1 : 0;
                      controller.updateTask(task);
                    },
                    activeColor: Colors.green,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _numTextWidget(
                        (taskModel.grandTotal ?? 0).toString(), "已持续",
                        secondaryText: taskModel.durationDays == 0
                            ? "/∞"
                            : "/${taskModel.durationDays}天"),
                    _numTextWidget(
                        (taskModel.continuousDays ?? 0).toString(), "最长持续",
                        secondaryText: "天"),
                    _numTextWidget(
                        (taskModel.monthTotal ?? 0).toString(), "本月已打卡",
                        secondaryText: "天"),
                  ]),
            ),
            const HorizontalDivider(),
            Text(
              "任务始自:${taskModel.beginDate}",
              style: TextStyle(color: AppColors.grey999, fontSize: 12.sp),
            ).paddingSymmetric(horizontal: 10.w, vertical: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _numTextWidget(String mainText, String title,
      {String? secondaryText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mainText,
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800),
            ),
            if (secondaryText?.isNotEmpty == true)
              Text(
                secondaryText!,
                style: TextStyle(color: AppColors.grey999, fontSize: 14.sp),
              )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(color: AppColors.subtitle666, fontSize: 14.sp),
        )
      ],
    );
  }
}
