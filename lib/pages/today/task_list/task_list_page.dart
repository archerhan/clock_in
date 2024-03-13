import 'package:clock_in/pages/today/task_list/task_list_controller.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class TaskListPage extends GetView<TaskListController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("全部任务"),
      ),
      body: _taskList(),
    );
  }

  Widget _taskList() {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
            );
          },
        ));
  }

  Widget _taskItem(TaskModel taskModel) {
    return Container(
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
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }
}
