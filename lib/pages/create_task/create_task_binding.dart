import 'package:clock_in/pages/create_task/create_task_controller.dart';
import 'package:get/get.dart';

class CreateTaskBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CreateTaskController());
  }
}