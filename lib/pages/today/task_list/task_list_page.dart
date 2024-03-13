import 'package:clock_in/pages/today/task_list/task_list_controller.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class TaskListPage extends GetView<TaskListController> {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("全部任务"),
      ),
    );
  }
}
