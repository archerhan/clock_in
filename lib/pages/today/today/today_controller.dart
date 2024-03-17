import 'package:clock_in/manager/check_record_dao.dart';
import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class TodayController extends GetxController {
  var today = DateTime.now();
  // 往前推三个月的第一天
  var calendarFirstDay =
      DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
  // 获取当月最后一天
  var calendarLastDay =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  var todayTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    loadTodayTasks();
    super.onInit();
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
  Future loadTodayTasks() async {
    var taskDao = TaskDao();
    var allTasks = await taskDao.queryAllTask();
    final weekday = today.weekday;
    var tasks = allTasks
        .where((element) =>
            element.isActive == 1 &&
            element.beginDate != null &&
            DateTime.parse(element.beginDate!).isBefore(today) &&
            (element.plan?.contains(weekday.toString()) == true ||
                element.plan?.isEmpty == true))
        .toList();
    logger.d("今日任务: ${tasks.map((e) => e.taskName).toList()}");
    // 生成打卡记录
    for (var task in tasks) {
      await generateCheckRecord(task);
    }
    logger.d("全部任务生成打卡记录完成");
    todayTasks.value = tasks;
  }

  /// 根据任务生成打卡记录
  /// 1. 判断是否生成了今日的打卡记录
  /// 2. 如果没有生成,则生成打卡记录, 并更新date字段为今天的日期(格式为年-月-日), checkCount字段为0, 并将id添加到task的records字段
  Future generateCheckRecord(TaskModel task) async {
    logger.d("开始生成${task.taskName}的打卡记录");
    var records =
        task.records?.isNotEmpty == true ? task.records!.split(";") : [];
    var dateSet = <String>{};
    var todayDateString = today.toString().split(' ')[0];
    for (var record in records) {
      var recordModel =
          await CheckRecordDao().queryCheckRecord(int.parse(record));
      if (recordModel?.date != null) {
        dateSet.add(recordModel!.date!);
      }
    }
    if (!dateSet.contains(todayDateString)) {
      var checkRecordModel = CheckRecordModel(
          taskId: task.id, date: todayDateString, note: "", checkCount: 0);
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
    var records = task.records!.split(";");
    var dateSet = <String>{};
    for (var record in records) {
      var recordModel =
          await CheckRecordDao().queryCheckRecord(int.parse(record));
      if (recordModel?.date != null) {
        dateSet.add(recordModel!.date!);
      }
    }
    var checkCount = 0;
    for (var date in dateSet) {
      var recordModel = await CheckRecordDao()
          .queryCheckRecordByDate(task.id!, DateTime.parse(date));
      if (recordModel?.checkCount == task.checkCount) {
        checkCount = 0;
      } else {
        checkCount = recordModel!.checkCount! + 1;
      }
      recordModel!.checkCount = checkCount;
      await CheckRecordDao().updateCheckRecord(recordModel);
    }
    var grandTotal = dateSet.length;
    var continuousDays = calculateMaxContinuousDays(dateSet);
    task.grandTotal = grandTotal;
    task.continuousDays = continuousDays;
    await TaskDao().updateTask(task);
  }

  /// 计算最长连续打卡天数
  int calculateMaxContinuousDays(Set<String> dateSet) {
    var dateList = dateSet.toList();
    dateList.sort((a, b) => a.compareTo(b));
    var continuousDays =
        1; // Start from 1 as a single day is also a continuous period
    var maxContinuousDays = 1;
    for (var i = 0; i < dateList.length - 1; i++) {
      var date1 = DateTime.parse(dateList[i]);
      var date2 = DateTime.parse(dateList[i + 1]);
      if (date2.difference(date1).inDays == 1) {
        continuousDays++;
        if (continuousDays > maxContinuousDays) {
          maxContinuousDays = continuousDays;
        }
      } else {
        continuousDays = 1; // Reset if dates are not continuous
      }
    }
    return maxContinuousDays;
  }
}
