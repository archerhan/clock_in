import 'package:get/get.dart';
import 'package:clock_in/pages/chart/chart_controller.dart';

class ChartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChartController());
  }
}
