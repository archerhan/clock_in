import 'package:get/get.dart';
import 'package:clock_in/pages/reward/reward_controller.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RewardController());
  }
}
