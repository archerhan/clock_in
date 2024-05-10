import 'package:clock_in/manager/db/reward_dao.dart';
import 'package:clock_in/pages/reward/reward_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class RewardController extends GetxController {
  var rewardList = <RewardModel>[].obs;

  @override
  void onReady() {
    loadAllRewards();
    super.onReady();
  }

  // 获取所有的任务奖励
  Future loadAllRewards() async {
    var list = await RewardDao().queryAllReward();
    rewardList.assignAll(list);
    logger.d(
        "查询全部任务奖励:${rewardList.map((element) => element.rewardName).toList()}");
  }
}
