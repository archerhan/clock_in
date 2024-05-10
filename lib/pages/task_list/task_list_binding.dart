import 'package:clock_in/pages/task_list/task_list_controller.dart';
import 'package:get/get.dart';

class TaskListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskListController>(() => TaskListController());
  }
  
}