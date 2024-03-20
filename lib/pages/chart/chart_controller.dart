import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final taskNumCon = FlipCardController();
  final longestDayCon = FlipCardController();
  final longestContinueCon = FlipCardController();

  var allTasks = <TaskModel>[].obs;

  var taskNum = 0.obs;
  var longestDay = 0.obs;
  var longestContinue = 0.obs;

  @override
  void onReady() {
    getAllTask();
    super.onReady();
  }

  // 获取全部任务, 包括已完成和未完成, 关闭的
  // 任务数量: 查出来的数组长度
  // 最长打卡天数: 查出来的数组中, grandTotal最大的
  // 最长连续打卡天数: 查出来的数组中, continuousDays最大的
  Future getAllTask() async {
    allTasks.value = await TaskDao().queryAllTask();
    if (allTasks.isNotEmpty) {
      taskNum.value = allTasks.length;
      longestDay.value =
          allTasks.map((e) => e.grandTotal).reduce((a, b) => a! > b! ? a : b) ??
              0;
      longestContinue.value = allTasks
              .map((e) => e.continuousDays)
              .reduce((a, b) => a! > b! ? a : b) ??
          0;
    }
  }
}
