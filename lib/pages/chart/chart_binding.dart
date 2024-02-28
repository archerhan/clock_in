import 'package:get/get.dart';
import 'package:clock_in/pages/chart/chart_controller.dart';

class PropertyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PropertyController());
  }
}
