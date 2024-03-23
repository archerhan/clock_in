import 'dart:convert';
import 'dart:math';

import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/today/create_task/icons_model.dart';
import 'package:clock_in/pages/today/task_list/task_list_controller.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/random_material_color.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class CreateTaskController extends GetxController {
  TaskModel? _currentTask;
  bool get isCreateTask => _currentTask == null;
  // 任务名称
  final taskNameTextController = TextEditingController();
  // 开始时间
  var selectedStartDate = DateTime.now().obs;
  // 持续时间 0为永远
  var duration = 0.obs;
  // 重复 0为每天
  var repeatValue = <int>[].obs;
  // 每日打卡次数
  var checkCountPerDay = 1.obs;
  // 是否开启提醒
  var notificationIsOn = false.obs;
  // 提醒时间,数组用;隔开
  var notificationTimes = <String>[].obs;
  // 初始提醒时间
  final initialNotificationTime = "0-08:30";
  // 提醒时间列表
  final notificationTuples = const [
    Tuple2(0, "每天"),
    Tuple2(1, "周一"),
    Tuple2(2, "周二"),
    Tuple2(3, "周三"),
    Tuple2(4, "周四"),
    Tuple2(5, "周五"),
    Tuple2(6, "周六"),
    Tuple2(7, "周日"),
  ];
  // 选择的提醒时间
  var selectedNotificationTime = "".obs;
  // 口号
  final sloganTextController = TextEditingController();
  // 选择的颜色
  var selectedColor = "".obs;
  // 选择的图标
  var selectedIcon = IconAssetModel("", false).obs;
  // 图标列表
  var iconList = <IconCategoryModel>[].obs;

  @override
  void onInit() {
    loadIcons();
    _currentTask = Get.arguments;
    if (!isCreateTask) {
      // 如果是编辑任务
      initData();
    } else {
      // 如果是新建任务
      selectedColor.value = RandomMaterialColor.getRandomColorValue();
      sloganTextController.text = shortPhases();
    }
    super.onInit();
  }

  // 创建任务
  Future<void> createTask() async {
    if (taskNameTextController.text.isEmpty) {
      showToast("请填写任务名称");
      return;
    }
    if (selectedIcon.value.assetPath.isEmpty) {
      showToast("请选择图标");
      return;
    }
    final task = TaskModel(
        id: _currentTask?.id,
        taskName: taskNameTextController.text,
        icon: selectedIcon.value.assetPath,
        plan: repeatValue.join(";"),
        durationDays: duration.value,
        beginDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value),
        checkCount: checkCountPerDay.value,
        remindTime:
            notificationTimes.isNotEmpty ? notificationTimes.join(";") : "",
        slogan: sloganTextController.text,
        isActive: 1,
        color: selectedColor.value,
        createDT: !isCreateTask ? null : DateTime.now().toString(),
        updateDT: DateTime.now().toString());
    if (!isCreateTask) {
      await TaskDao().updateTask(task);
    } else {
      await TaskDao().insertTask(task);
    }
    Get.back();
  }

  // 删除任务
  Future<void> deleteTask() async {
    if (!isCreateTask) {
      await TaskDao().deleteTask(_currentTask!.id!);
      await Get.find<TaskListController>().loadAllTask();
      // 同时删除任务的打卡记录
      await CheckRecordDao().deleteCheckRecordByTaskId(_currentTask!.id!);
    }
  }

  // 加载本地json数据
  Future<void> loadIcons() async {
    String jsonString = await rootBundle.loadString(Assets.json.icons);
    var jsonData = jsonDecode(jsonString);
    var data = <IconCategoryModel>[];
    for (var category in jsonData["allIcons"]) {
      data.add(IconCategoryModel.fromJson(category));
    }
    iconList.value = data;
  }

  // 选择图标
  void selectIcon(IconAssetModel iconAssetModel) {
    selectedIcon.value = iconAssetModel;
    for (var category in iconList) {
      for (var icon in category.iconAssets) {
        icon.isSelected = false;
        if (icon.assetPath == iconAssetModel.assetPath) {
          icon.isSelected = true;
        }
      }
    }
    iconList.refresh();
  }

  // 添加通知时间
  void addNotificationTime(String time) {
    notificationTimes.add(time);
  }

  // 移除通知时间
  void removeNotificationTime(int index) {
    notificationTimes.removeAt(index);
    if (notificationTimes.isEmpty) {
      notificationIsOn.value = false;
    }
  }

  // 选择提醒时间
  String getNotificationDayName(int day) {
    switch (day) {
      case 1:
        return "周一";
      case 2:
        return "周二";
      case 3:
        return "周三";
      case 4:
        return "周四";
      case 5:
        return "周五";
      case 6:
        return "周六";
      case 7:
        return "周日";
      default:
        return "每天";
    }
  }

  // 选择分类名字
  String getCategoryNameBy(IconCategory category) {
    switch (category) {
      case IconCategory.business:
        return "商务";
      case IconCategory.entertainment:
        return "娱乐";
      case IconCategory.family:
        return "家庭";
      case IconCategory.food:
        return "饮食";
      case IconCategory.income:
        return "收入";
      case IconCategory.medical:
        return "医疗";
      case IconCategory.shopping:
        return "购物";
      case IconCategory.skill:
        return "技能";
      case IconCategory.sport:
        return "运动";
      case IconCategory.traffic:
        return "交通";
      case IconCategory.others:
        return "其他";
    }
  }

  void initData() {
    taskNameTextController.text = _currentTask?.taskName ?? "";
    selectedStartDate.value = DateTime.parse(_currentTask?.beginDate ?? "");
    duration.value = _currentTask?.durationDays ?? 0;
    repeatValue.value = _currentTask?.plan?.isNotEmpty == true
        ? (_currentTask!.plan!.split(";").map(int.parse).toList())
        : [];
    checkCountPerDay.value = _currentTask?.checkCount ?? 1;
    notificationIsOn.value = _currentTask?.remindTime?.isNotEmpty ?? false;
    notificationTimes.value = _currentTask?.remindTime == ""
        ? []
        : _currentTask!.remindTime!.split(";");
    sloganTextController.text = _currentTask?.slogan ?? "";
    selectedColor.value = _currentTask?.color ?? "";
    selectedIcon.value = IconAssetModel(_currentTask?.icon ?? "", true);
  }

  // 随机生成一句励志名言
  String shortPhases() {
    final phases = [
      "不怕慢，只怕站。",
      "坚持就是胜利。",
      "不经历风雨，怎能见彩虹。",
      "路漫漫其修远兮，吾将上下而求索。",
      "成功没有捷径，只有坚持不懈的努力。",
      "不要轻言放弃，因为你不知道明天的你会遇到什么惊喜。",
      "只要路是对的，就不怕路远。",
      "坚持不懈，直到成功。",
      "每一次努力都是一次积累。",
      "不要停下脚步，因为你还未到达终点。",
      "不要因为一次失败而放弃你的梦想。",
      "坚持是成功的唯一捷径。",
      "只有坚持不懈，才能创造奇迹。",
      "不要害怕失败，因为失败是成功之母。",
      "不要等待机会，而要创造机会。",
      "精诚所至，金石为开。",
      "不经一翻彻骨寒，怎得梅花扑鼻香。",
      "日日行，不怕千万里；常常做，不怕千万事。",
      "成大事不在于力量的大小，而在于能坚持多久。",
      "毅力是永久的享受。",
      "穷且益坚，不坠青云之志。",
      "读不在三更五鼓，功只怕一曝十寒。",
      "锲而舍之，朽木不折；坚持不懈，金石可镂。",
      "逆水行舟使劲撑，一篙松劲退千寻",
      "古人常识无遗力，少壮工夫老始成。",
      "点点滴滴的藏，集成了一大仓。",
      "为学须刚与恒，不刚则隋隳，不恒则退",
      "看日出必须守到拂晓。",
      "才气就是长期的坚持不懈。",
      "宝剑锋从磨砺出，梅花香自苦寒来。",
      "立志不坚，终不济事。",
      "坚持者能在命运风暴中奋斗。",
      "锲而不舍，金石可镂。",
      "天行健，君子以自强不息。",
      "事业常成于坚忍，毁于急躁。",
      "学习本无底，前进莫彷徨。",
      "三军可夺帅也，匹夫不可夺志也。",
      "进锐退速。",
    ];
    return phases[Random().nextInt(phases.length)];
  }
}
