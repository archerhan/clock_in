import 'package:clock_in/pages/today/today_controller.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/root/root_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RootController());
    Get.lazyPut(() => TodayController());
  }
}
