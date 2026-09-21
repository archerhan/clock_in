import 'dart:math';

import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/reward_dao.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/reward/reward_model.dart';
import 'package:clock_in/pages/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// 演示数据。
///
/// 首次启动时(本地数据库为空)写入一批任务、打卡记录和奖励,
/// 便于直接看到首页 / 统计 / 奖励等页面的完整效果。
///
/// 只在 debug 构建下自动生效; release 构建默认不写入,
/// 需要时可以通过 `--dart-define=SEED_DEMO_DATA=true` 打开。
class DemoDataManager {
  DemoDataManager._();
  static final DemoDataManager instance = DemoDataManager._();

  static const bool enableDemoData =
      kDebugMode || bool.fromEnvironment('SEED_DEMO_DATA');

  /// 本地数据库为空时写入演示数据, 已有数据则直接跳过。
  Future<void> seedIfNeeded() async {
    if (!enableDemoData) {
      return;
    }
    try {
      final existing = await TaskDao().queryAllTask();
      if (existing.isNotEmpty) {
        return;
      }
      await _seed();
      logger.d("演示数据写入完成");
    } catch (e, s) {
      // 演示数据失败不能影响 App 启动
      logger.e("演示数据写入失败: $e\n$s");
    }
  }

  Future<void> _seed() async {
    final today = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final nowText = today.toString();

    for (final demo in _demoTasks) {
      final beginDate = today.subtract(Duration(days: demo.daysAgo));
      final task = TaskModel(
        taskName: demo.name,
        icon: demo.icon,
        plan: demo.plan,
        durationDays: demo.durationDays,
        beginDate: dateFormat.format(beginDate),
        checkCount: demo.checkCount,
        remindTime: demo.remindTime,
        slogan: demo.slogan,
        isActive: 1,
        createDT: beginDate.toString(),
        updateDT: nowText,
        color: demo.color,
        grandTotal: 0,
        continuousDays: 0,
      );
      var taskId = await TaskDao().insertTask(task);
      task.id = taskId;

      final records = await _buildRecords(
        taskId: taskId,
        beginDate: beginDate,
        today: today,
        plan: demo.plan,
        checkCountPerDay: demo.checkCount,
        pattern: demo.pattern,
      );
      if (records.isEmpty) {
        continue;
      }
      task.records = records.map((e) => e.id.toString()).join(";");
      task.grandTotal =
          records.where((e) => (e.checkCount ?? 0) > 0).length;
      task.continuousDays = _maxContinuousDays(records);
      await TaskDao().updateTask(task);

      await _seedRewards(
        demo: demo,
        task: task,
        records: records,
        nowText: nowText,
      );
    }
  }

  /// 生成某个任务从开始日期到今天的打卡记录。
  /// [pattern] 中 1 表示当天打卡, 0 表示漏卡, 会循环使用。
  Future<List<CheckRecordModel>> _buildRecords({
    required int taskId,
    required DateTime beginDate,
    required DateTime today,
    required String plan,
    required int checkCountPerDay,
    required List<int> pattern,
  }) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final records = <CheckRecordModel>[];
    final totalDays = today.difference(beginDate).inDays;
    final planDays = plan.isEmpty
        ? const <int>[1, 2, 3, 4, 5, 6, 7]
        : plan.split(";").where((e) => e.isNotEmpty).map(int.parse).toList();
    var index = 0;

    for (var i = 0; i <= totalDays; i++) {
      final day = beginDate.add(Duration(days: i));
      // 只给计划内的日期生成记录, 与 App 实际逻辑保持一致
      if (!planDays.contains(day.weekday)) {
        continue;
      }
      final isChecked = pattern[index % pattern.length] == 1;
      index++;
      final model = CheckRecordModel(
        taskId: taskId,
        date: dateFormat.format(day),
        note: "",
        checkCount: isChecked ? checkCountPerDay : 0,
        createDT: day.toString(),
        updateDT: day.toString(),
      );
      final id = await CheckRecordDao().insertCheckRecord(model);
      model.id = id;
      records.add(model);
    }
    return records;
  }

  int _maxContinuousDays(List<CheckRecordModel> records) {
    final dates = records
        .where((e) => (e.checkCount ?? 0) > 0 && e.date?.isNotEmpty == true)
        .map((e) => DateTime.parse(e.date!))
        .toList()
      ..sort((a, b) => a.compareTo(b));
    if (dates.isEmpty) {
      return 0;
    }
    var maxStreak = 1;
    var currentStreak = 1;
    for (var i = 1; i < dates.length; i++) {
      if (dates[i].difference(dates[i - 1]).inDays == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
      maxStreak = max(maxStreak, currentStreak);
    }
    return maxStreak;
  }

  Future<void> _seedRewards({
    required _DemoTask demo,
    required TaskModel task,
    required List<CheckRecordModel> records,
    required String nowText,
  }) async {
    if (demo.rewardName == null) {
      return;
    }
    final checkDays = records.where((e) => (e.checkCount ?? 0) > 0).length;
    final reward = RewardModel(
      rewardName: demo.rewardName,
      taskId: task.id,
      taskName: task.taskName,
      duration: checkDays,
      condition: demo.rewardCondition,
      icon: demo.rewardIcon,
      beginDate: task.beginDate,
      finishDate: null,
      createDT: nowText,
      updateDT: nowText,
      color: demo.rewardColor,
    );
    await RewardDao().insertReward(reward);
  }
}

class _DemoTask {
  const _DemoTask({
    required this.name,
    required this.icon,
    required this.color,
    required this.slogan,
    required this.daysAgo,
    this.plan = "",
    this.checkCount = 1,
    this.durationDays = 0,
    this.remindTime = "",
    this.pattern = const [1, 1, 1, 1, 1, 1, 1],
    this.rewardName,
    this.rewardCondition = 30,
    this.rewardIcon = "",
    this.rewardColor = "4caf50",
  });

  final String name;
  final String icon;
  final String color;
  final String slogan;

  /// 任务开始于几天前
  final int daysAgo;

  /// 1-7 表示周一到周日, 空字符串表示每天
  final String plan;
  final int checkCount;
  final int durationDays;
  final String remindTime;

  /// 打卡节律, 1 打卡 0 漏卡, 循环使用
  final List<int> pattern;

  final String? rewardName;
  final int rewardCondition;
  final String rewardIcon;
  final String rewardColor;
}

const _demoTasks = <_DemoTask>[
  _DemoTask(
    name: "早起",
    icon: "assets/images/family/family_clock.png",
    color: "ffb300",
    slogan: "早起的鸟儿有虫吃",
    daysAgo: 96,
    remindTime: "0-06:30",
    pattern: [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1],
  ),
  _DemoTask(
    name: "跑步",
    icon: "assets/images/sport/sport_running.png",
    color: "f44336",
    slogan: "跑起来, 就有风",
    daysAgo: 74,
    plan: "1;3;5;7",
    remindTime: "0-19:30",
    pattern: [1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1],
    rewardName: "买一双新跑鞋",
    rewardCondition: 40,
    rewardIcon: "assets/images/sport/sport_running.png",
    rewardColor: "f44336",
  ),
  _DemoTask(
    name: "读书",
    icon: "assets/images/skill/skill_book.png",
    color: "3f51b5",
    slogan: "腹有诗书气自华",
    daysAgo: 120,
    remindTime: "0-21:30",
    pattern: [1, 1, 1, 0, 1, 1, 1, 1, 0, 1],
    rewardName: "换一个大书架",
    rewardCondition: 100,
    rewardIcon: "assets/images/skill/skill_book.png",
    rewardColor: "3f51b5",
  ),
  _DemoTask(
    name: "背单词",
    icon: "assets/images/skill/skill_study.png",
    color: "009688",
    slogan: "每天 20 个, 一年就是 7300 个",
    daysAgo: 58,
    checkCount: 2,
    durationDays: 100,
    pattern: [1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0],
  ),
  _DemoTask(
    name: "喝水",
    icon: "assets/images/food/food_milk.png",
    color: "03a9f4",
    slogan: "每天八杯水",
    daysAgo: 30,
    checkCount: 8,
    durationDays: 60,
    pattern: [1, 1, 1, 1, 1, 1, 1, 0, 1, 1],
  ),
  _DemoTask(
    name: "冥想",
    icon: "assets/images/others/others_garden.png",
    color: "9c27b0",
    slogan: "十分钟, 和自己待一会儿",
    daysAgo: 21,
    remindTime: "0-22:00",
    pattern: [1, 1, 0, 0, 1, 1, 0],
    rewardName: "去一次温泉",
    rewardCondition: 60,
    rewardIcon: "assets/images/entertainment/entertainment_spa.png",
    rewardColor: "9c27b0",
  ),
  _DemoTask(
    name: "记账",
    icon: "assets/images/business/business_desk.png",
    color: "795548",
    slogan: "知道钱去哪儿了",
    daysAgo: 45,
    plan: "5",
    pattern: [1, 1, 1, 0, 1],
  ),
];
