import 'package:get/get.dart';
import 'package:clock_in/pages/task/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController());
  }
}
