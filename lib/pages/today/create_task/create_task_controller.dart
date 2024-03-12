import 'dart:convert';

import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/create_task/icons_model.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/random_material_color.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class CreateTaskController extends GetxController {
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
    selectedColor.value = RandomMaterialColor.getRandomColorValue();
    super.onInit();
  }

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
        taskName: taskNameTextController.text,
        icon: selectedIcon.value.assetPath,
        plan: repeatValue.join(";"),
        durationDays: duration.value,
        beginDate: DateFormat('yyyy-MM-dd').format(selectedStartDate.value),
        checkCount: checkCountPerDay.value,
        remindTime: notificationTimes.join(";"),
        slogan: sloganTextController.text,
        isActive: 1,
        sort: 0,
        color: selectedColor.value,
        createDT: DateTime.now().toString(),
        updateDT: DateTime.now().toString());
    await TaskDao().insertTask(task);
    Get.back();
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

  void addNotificationTime(String time) {
    notificationTimes.add(time);
  }

  void removeNotificationTime(int index) {
    notificationTimes.removeAt(index);
    if (notificationTimes.isEmpty) {
      notificationIsOn.value = false;
    }
  }

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
}
