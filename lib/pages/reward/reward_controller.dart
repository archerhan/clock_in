import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/pages/reward/reward_model.dart';
import 'package:clock_in/utils/random_material_color.dart';
import 'package:get/get.dart';

class RewardController extends GetxController {
  var rewardList = <RewardModel>[].obs;

  @override
  void onInit() {
    /// mock data
    rewardList.assignAll([
      RewardModel(
          id: 1,
          rewardName: "奖励个猫儿",
          taskId: 1,
          taskName: "任务1",
          duration: 1,
          condition: 1,
          icon: Assets.images.family.familyCat.path,
          beginDate: "2021-01-01",
          finishDate: "2021-01-01",
          createDT: "2021-01-01",
          updateDT: "2021-01-01",
          color: RandomMaterialColor.getRandomColorValue()),
      RewardModel(
          id: 2,
          rewardName: "奖励个狗子",
          taskId: 2,
          taskName: "任务2",
          duration: 1,
          condition: 2,
          icon: Assets.images.family.familyDog.path,
          beginDate: "2021-01-01",
          finishDate: "2021-01-01",
          createDT: "2021-01-01",
          updateDT: "2021-01-01",
          color: RandomMaterialColor.getRandomColorValue()),
      RewardModel(
          id: 3,
          rewardName: "奖励个锤子",
          taskId: 3,
          taskName: "任务3",
          duration: 1,
          condition: 3,
          icon: Assets.images.family.familyHammer.path,
          beginDate: "2021-01-01",
          finishDate: "2021-01-01",
          createDT: "2021-01-01",
          updateDT: "2021-01-01",
          color: RandomMaterialColor.getRandomColorValue()),
    ]);
    super.onInit();
  }
}
