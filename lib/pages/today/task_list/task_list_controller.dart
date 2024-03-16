import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
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
    taskList.value = tasks;
    logger.d("查询全部任务:${taskList.map((element) => element.taskName).toList()}");
  }

  /// 更新任务
  Future updateTask(TaskModel model, {bool needReload = true}) async {
    final res = await TaskDao().updateTask(model);
    logger.d("更新Task:${model.taskName}, 结果:${res >= 1 ? "✅" : "❌"}");
    if (needReload) {
      await loadAllTask();
    }
  }

  /// 重新排序
  Future reorder(int oldIndex, int newIndex) async {
    logger.d("oldIndex:$oldIndex, newIndex:$newIndex");
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    taskList.insert(newIndex, taskList.removeAt(oldIndex));
    for (var i = 0; i < taskList.length; i++) {
      taskList[i].sort = i + 1;
      await updateTask(taskList[i], needReload: false);
    }
    loadAllTask();
  }
}
