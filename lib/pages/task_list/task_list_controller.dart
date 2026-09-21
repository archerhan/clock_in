import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/manager/notification_manager.dart';
import 'package:clock_in/pages/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class TaskListController extends GetxController {
  var taskList = <TaskModel>[].obs;

  @override
  void onInit() {
    loadAllTask();
    super.onInit();
  }

  /// 查询全部任务
  Future loadAllTask() async {
    var tasks = await TaskDao().queryAllTask();
    tasks.sort((a, b) => a.sort!.compareTo(b.sort!));
    for (var task in tasks) {
      task.monthTotal = await calculateMonthCheckCount(task);
    }
    taskList.value = tasks;
    logger.d("查询全部任务:${taskList.map((element) => element.taskName).toList()}");
  }

  /// 更新任务
  Future updateTask(TaskModel model, {bool needReload = true}) async {
    final res = await TaskDao().updateTask(model);
    // 如果关闭任务, 则删除所有提醒
    if (model.isActive == 0) {
      await NotificationManager.instance.cancelNotificationByTask(model);
    } else {
      await NotificationManager.instance.scheduleNotification(model);
    }
    logger.d("更新Task:${model.taskName}, 结果:${res >= 1 ? "✅" : "❌"}");
    if (needReload) {
      await loadAllTask();
    }
  }

  /// 重新排序
  /// [newIndex] 为移除 [oldIndex] 之后的最终位置(由 onReorderItem 提供)
  Future reorder(int oldIndex, int newIndex) async {
    logger.d("oldIndex:$oldIndex, newIndex:$newIndex");
    taskList.insert(newIndex, taskList.removeAt(oldIndex));
    for (var i = 0; i < taskList.length; i++) {
      taskList[i].sort = i + 1;
      await updateTask(taskList[i], needReload: false);
    }
    loadAllTask();
  }

  // 计算本月已经打卡天数
  Future calculateMonthCheckCount(TaskModel task) async {
    var records = task.records;
    if (records == null || records.isEmpty) {
      return 0;
    }
    var recordList = records.split(";");
    var count = 0;
    for (var record in recordList) {
      if (record.isNotEmpty) {
        final checkRecord = await CheckRecordDao().queryCheckRecord(int.parse(record));
        if (checkRecord == null) {
          continue;
        }
        var date = DateTime.parse(checkRecord.date!);
        if (date.year == DateTime.now().year && date.month == DateTime.now().month) {
          count++;
        }
      }
    }
    return count;
  }

}
