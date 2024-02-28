import 'package:get/get.dart';
import 'package:clock_in/pages/today/today_controller.dart';

class TodayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodayController());
  }
}
