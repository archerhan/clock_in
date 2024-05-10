import 'package:clock_in/pages/create_reward/create_reward_controller.dart';
import 'package:get/get.dart';

class CreateRewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateRewardController());
  }
}
