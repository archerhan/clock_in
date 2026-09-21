import 'dart:math';

import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class TodayController extends GetxController {
  var selectedDay = DateTime.now().obs;
  // 往前推三个月的第一天
  var calendarFirstDay =
      DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  // 获取当月最后一天
  var calendarLastDay = DateTime.now();

  // 今日的打卡任务
  var todayTasks = <TaskModel>[].obs;

  // 每日打卡次数
  var dailyCheckCountData = <String, int>{}.obs;

  // 默认显示2周
  var isExpanedCalendar = false.obs;

  @override
  void onReady() {
    loadData();
    super.onReady();
  }

  Future loadData() async {
    await loadSelectDayTasks();
    await getDailyCheckCount();
  }

  /// 加载今日任务
  /// 1. 从数据库中获取所有任务
  /// 2. 过滤出今日需要打卡的任务
  /// 3. 更新todayTasks
  /// 今日任务的判断条件:
  /// 1. isActive == 1
  /// 2. beginDate != null
  /// 3. beginDate < today
  /// 4. weekDay in plan
  /// 5. task is not completed
  Future loadSelectDayTasks() async {
    var taskDao = TaskDao();
    var allTasks = await taskDao.queryAllTask();
    final weekday = selectedDay.value.weekday;
    var tasks = allTasks
        .where((element) =>
            element.isActive == 1 &&
            element.beginDate != null &&
            DateTime.parse(element.beginDate!).isBefore(selectedDay.value) &&
            (element.plan?.contains(weekday.toString()) == true ||
                element.plan?.isEmpty == true))
        .toList();
    // 按sort排序
    tasks.sort((a, b) => a.sort!.compareTo(b.sort!));
    logger.d("今日任务: ${tasks.map((e) => e.taskName).toList()}");
    // 生成打卡记录
    for (var task in tasks) {
      await generateCheckRecord(task);
      task.recordsData = await getCheckRecords(task);
    }
    logger.d("全部任务生成打卡记录完成");
    todayTasks.value = tasks;
  }

  // 获取当天所有任务是否有打卡记录
  // 输入DateTime, 输出Future<bool>
  // 1. 遍历所有任务
  // 2. 获取每个任务的打卡记录
  // 3. 只有打卡记录的checkCount > 0时, 才返回true
  Future<bool> hasCheckRecord(DateTime date) async {
    var taskDao = TaskDao();
    var allTasks = await taskDao.queryAllTask();
    final weekday = date.weekday;
    var tasks = allTasks
        .where((element) =>
            element.isActive == 1 &&
            element.beginDate != null &&
            DateTime.parse(element.beginDate!).isBefore(date) &&
            (element.plan?.contains(weekday.toString()) == true ||
                element.plan?.isEmpty == true))
        .toList();
    for (var task in tasks) {
      var records =
          task.records?.isNotEmpty == true ? task.records!.split(";") : [];
      for (var record in records) {
        var recordModel =
            await CheckRecordDao().queryCheckRecord(int.parse(record));
        if (recordModel?.checkCount != 0) {
          return true;
        }
      }
    }
    return false;
  }

  // 获取当前任务的所有打卡记录
  Future<List<CheckRecordModel>> getCheckRecords(TaskModel task) async {
    var records =
        task.records?.isNotEmpty == true ? task.records!.split(";") : [];
    var recordList = <CheckRecordModel>[];
    for (var record in records) {
      var recordModel =
          await CheckRecordDao().queryCheckRecord(int.parse(record));
      if (recordModel != null) {
        recordList.add(recordModel);
      }
    }
    return recordList;
  }

  /// 根据任务生成打卡记录
  /// 1. 判断是否生成了今日的打卡记录
  /// 2. 如果没有生成,则生成打卡记录, 并更新date字段为今天的日期(格式为年-月-日), checkCount字段为0, 并将id添加到task的records字段
  Future generateCheckRecord(TaskModel task) async {
    logger.d("开始生成${task.taskName}的打卡记录");
    var records =
        task.records?.isNotEmpty == true ? task.records!.split(";") : [];
    var dateSet = <String>{};
    var todayDateString = selectedDay.toString().split(' ')[0];
    for (var record in records) {
      var recordModel =
          await CheckRecordDao().queryCheckRecord(int.parse(record));
      if (recordModel?.date != null) {
        dateSet.add(recordModel!.date!);
      }
    }
    if (!dateSet.contains(todayDateString)) {
      var checkRecordModel = CheckRecordModel(
          taskId: task.id,
          date: todayDateString,
          note: "",
          checkCount: 0,
          createDT: DateTime.now().toString(),
          updateDT: DateTime.now().toString());
      logger.d("记录生成完成: $checkRecordModel, 准备插入数据库");
      var id = await CheckRecordDao().insertCheckRecord(checkRecordModel);
      logger.d("插入数据库完成, id: $id, 准备更新task的records字段");
      records.add(id.toString());
      logger.d("更新task的records字段完成, record现有记录:$records,准备更新数据库");
      task.records = records.join(";");
      await TaskDao().updateTask(task);
      logger.d("更新task数据库完成");
    }
  }

  /// 点击完成的时候同步更新数据库
  /// 1. 更新CheckRecordModel的checkCount字段, 当checkCount < task.checkCount时,则将checkCount +1, 当checkCount == task.checkCount时, 则将checkCount重置为0
  /// 2. 更新task的grandTotal字段
  /// 3. 更新task的continuousDays字段
  Future checkTask(TaskModel task) async {
    logger.d("开始打卡${task.taskName}...");
    var recordsList = task.recordsData ?? [];

    // var records = task.records!.split(";");
    // for (var record in records) {
    //   var recordModel =
    //       await CheckRecordDao().queryCheckRecord(int.parse(record));
    //   if (recordModel != null) {
    //     recordsList.add(recordModel);
    //   }
    // }
    logger.d("获取今日打卡记录...");
    final todayDateString = selectedDay.value.toString().split(' ')[0];
    var todayRecord = recordsList.firstWhere(
        (element) => element.date == todayDateString,
        orElse: () => CheckRecordModel());
    // 记录可能还不存在(如历史数据/当天记录未生成), 此时先补一条今天的记录
    if (todayRecord.id == null) {
      todayRecord = CheckRecordModel(
          taskId: task.id,
          date: todayDateString,
          note: "",
          checkCount: 0,
          createDT: DateTime.now().toString(),
          updateDT: DateTime.now().toString());
      todayRecord.id = await CheckRecordDao().insertCheckRecord(todayRecord);
      final recordIds = [
        ...(task.records?.isNotEmpty == true
            ? task.records!.split(";").where((e) => e.isNotEmpty)
            : <String>[]),
        todayRecord.id.toString()
      ];
      task.records = recordIds.join(";");
      recordsList = [...recordsList, todayRecord];
    }
    var checkCount = 0;
    final todayCheckCount = todayRecord.checkCount ?? 0;
    final limit = task.checkCount ?? 1;
    if (todayCheckCount >= limit) {
      checkCount = 0;
    } else {
      checkCount = todayCheckCount + 1;
    }
    todayRecord.checkCount = checkCount;
    todayRecord.updateDT = DateTime.now().toString();
    await CheckRecordDao().updateCheckRecord(todayRecord);

    // 已持续天数 = 真正打过卡的天数, 而不是记录条数(每天都会生成一条记录)
    var grandTotal = recordsList
        .where((element) => (element.checkCount ?? 0) > 0)
        .length;
    var continuousDays = calculateMaxContinuousDays(recordsList);
    task.grandTotal = grandTotal;
    task.continuousDays = continuousDays;
    await TaskDao().updateTask(task);
    await loadData();
  }

  /// 计算最长连续打卡天数
  int calculateMaxContinuousDays(List<CheckRecordModel> records) {
    var dateList = records
        .where((element) =>
            (element.checkCount ?? 0) > 0 && element.date?.isNotEmpty == true)
        .map((e) => DateTime.parse(e.date!))
        .toList();
    if (dateList.isEmpty) {
      return 0;
    }
    dateList.sort((a, b) => a.compareTo(b));
    int maxStreak = 1;
    int currentStreak = 1;
    for (int i = 1; i < dateList.length; i++) {
      if (dateList[i].difference(dateList[i - 1]).inDays == 1) {
        currentStreak++;
      } else if (dateList[i] != dateList[i - 1]) {
        currentStreak = 1;
      }
      maxStreak = max(maxStreak, currentStreak);
    }
    return maxStreak;
  }

  // 查询全部的打卡记录
  // 按照date分组, 累加每组的checkCount
  // 最后按照date排序
  // 返回一个Map, key是DateTime, value是当天的打卡次数
  Future getDailyCheckCount() async {
    var map = <String, int>{};
    var list = await CheckRecordDao().queryAllCheckRecords();
    for (var element in list) {
      if (element.date?.isNotEmpty == true) {
        var date = element.date!;
        if (map.containsKey(date)) {
          map[date] = map[date]! + element.checkCount!;
        } else {
          map[date] = element.checkCount!;
        }
      }
    }
    dailyCheckCountData.value = map;
  }
}
