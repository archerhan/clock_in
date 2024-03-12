import 'dart:convert';

import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/pages/today/create_task/icons_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

class CreateTaskController extends GetxController {
  var taskNameTextController = TextEditingController();
  var selectedStartDate = DateTime.now().obs;
  var duration = 0.obs;
  var repeatValue = <int>[].obs;
  var checkCountPerDay = 1.obs;
  var notificationIsOn = false.obs;
  var notificationTimes = <String>[].obs;
  final initialNotificationTime = "0-08:30";
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
  var selectedNotificationTime = "".obs;
  var sloganTextController = TextEditingController();
  var selectedColor = "".obs;
  var selectedIcon = IconAssetModel("", false).obs;
  var iconList = <IconCategoryModel>[].obs;

  @override
  void onInit() {
    loadIcons();
    super.onInit();
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
