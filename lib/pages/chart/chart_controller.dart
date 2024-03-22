import 'package:clock_in/manager/check_record_dao.dart';
import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class ChartController extends GetxController {
  // 全部任务
  var allTasks = <TaskModel>[].obs;
  // 打卡热度
  var heatMapData = <DateTime, int>{}.obs;
  // 每周打卡次数
  var weekCheckData = <Tuple2>[].obs;
  // 任务打卡比例
  var taskCheckProportion = <Tuple2<TaskModel, int>>[].obs;

  var taskNum = 0.obs;
  var longestDay = 0.obs;
  var longestContinue = 0.obs;

  @override
  void onReady() {
    loadAllData();
    super.onReady();
  }

  void loadAllData() {
    getAllTask();
    getHeatMapData();
    getWeekCheckData();
    getTaskCheckProportion();
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

  // 查询全部的打卡记录
  // 按照date分组, 累加每组的checkCount
  // 最后按照date排序
  // 返回一个Map, key是DateTime, value是当天的打卡次数
  Future getHeatMapData() async {
    var map = <DateTime, int>{};
    var list = await CheckRecordDao().queryAllCheckRecords();
    for (var element in list) {
      if (element.date?.isNotEmpty == true) {
        var date = DateTime.tryParse(element.date!);
        if (map.containsKey(date)) {
          map[date!] = map[date]! + element.checkCount!;
        } else {
          map[date!] = element.checkCount!;
        }
      }
    }
    heatMapData.value = map;
  }

  // 获取每周打卡的总次数
  // 按照第几周分组, 累加每组的checkCount
  // 生成一个Tuple2数组, item1是今年第几周, item2是当周的打卡次数, 并按item1排序
  Future getWeekCheckData() async {
    var map = <int, int>{};
    var list = await CheckRecordDao().queryAllCheckRecords();
    for (var element in list) {
      if (element.date?.isNotEmpty == true) {
        var date = DateTime.tryParse(element.date!);
        var week = DateTimeUtil.getWeekOfYear(date!);
        if (map.containsKey(week)) {
          map[week] = map[week]! + element.checkCount!;
        } else {
          map[week] = element.checkCount!;
        }
      }
    }
    var result = map.entries.toList();
    final sorted = result.map((e) => Tuple2(e.key, e.value)).toList();
    // 将之前的几周数据填上Tuple2(week, 0)
    for (var i = 1; i <= DateTimeUtil.getWeekOfYear(DateTime.now()); i++) {
      if (!sorted.any((element) => element.item1 == i)) {
        sorted.add(Tuple2(i, 0));
      }
    }
    // 按照week排序
    sorted.sort((a, b) => a.item1.compareTo(b.item1));
    weekCheckData.value = sorted;
  }

  // 获取任务打卡数
  // isActive == 1
  // 按照任务分组, 累加每组的checkCount
  // 生成一个Tuple2数组, item1是任务模型, item2是该任务的打卡次数占比
  Future getTaskCheckProportion() async {
    var tuples = <Tuple2<TaskModel, int>>[];
    var tasks = await TaskDao().queryAllTask();
    for (var task in tasks) {
      if (task.id != null) {
        var checkCount =
            await CheckRecordDao().queryCheckCountByTaskId(task.id!);
        tuples.add(Tuple2(task, checkCount));
      }
    }
    // 按item1的sort逆序排序
    final sorted = tuples.toList()
      ..sort((a, b) => a.item1.sort!.compareTo(b.item1.sort!));
    taskCheckProportion.value = sorted;
  }
}
