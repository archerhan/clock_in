import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/pages/today/today/task_record_model.dart';
import 'package:clock_in/utils/random_material_color.dart';
import 'package:get/get.dart';

class TodayController extends GetxController {
  var today = DateTime.now();
  // 往前推三个月的第一天
  var calendarFirstDay =
      DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  // 获取当月最后一天
  var calendarLastDay =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  var taskRecords = <TaskRecordModel>[].obs;

  @override
  void onInit() {
    // mock 4条 taskRecords
    taskRecords.addAll([
      TaskRecordModel(
          id: 1,
          taskName: '跑步',
          icon: Assets.images.sport.sportRunning.path,
          createDT: '2021-08-01',
          slogan: '每天跑步',
          color: RandomMaterialColor.getRandomColorValue(),
          rewardId: 1,
          duration: 30,
          checkCount: 2,
          totalCheckCount: 3),
      TaskRecordModel(
          id: 2,
          taskName: '学习',
          icon: Assets.images.sport.sportBadminton.path,
          createDT: '2021-08-01',
          slogan: '每天学习',
          color: RandomMaterialColor.getRandomColorValue(),
          rewardId: 1,
          duration: 30,
          checkCount: 0,
          totalCheckCount: 1),
      TaskRecordModel(
          id: 3,
          taskName: '阅读',
          icon: Assets.images.sport.sportBasketball.path,
          createDT: '2021-08-01',
          slogan: '每天阅读',
          color: RandomMaterialColor.getRandomColorValue(),
          rewardId: 1,
          duration: 30,
          checkCount: 1,
          totalCheckCount: 1),
      TaskRecordModel(
          id: 4,
          taskName: '写作',
          icon: Assets.images.sport.sportPingPong.path,
          createDT: '2021-08-01',
          slogan: '每天写作',
          color: RandomMaterialColor.getRandomColorValue(),
          rewardId: 1,
          duration: 30,
          checkCount: 1,
          totalCheckCount: 2),
    ]);
    super.onInit();
  }

  void onTaskItemTapped(TaskRecordModel taskRecordModel) {
    var model =
        taskRecords.firstWhere((element) => element.id == taskRecordModel.id);
    if (model.checkCount! < model.totalCheckCount!) {
      model.checkCount = model.checkCount! + 1;
    } else {
      model.checkCount = 0;
    }
    taskRecords.refresh();
  }
}
