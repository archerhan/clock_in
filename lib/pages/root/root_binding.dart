import 'package:clock_in/pages/chart/chart_controller.dart';
import 'package:clock_in/pages/reward/reward_controller.dart';
import 'package:clock_in/pages/setting/setting_controller.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/root/root_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RootController());
    Get.lazyPut(() => TodayController());
    Get.lazyPut(() => RewardController());
    Get.lazyPut(() => ChartController());
    Get.lazyPut(() => SettingController());
  }
}
