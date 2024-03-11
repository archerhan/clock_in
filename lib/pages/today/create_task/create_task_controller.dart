import 'dart:convert';

import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/pages/today/create_task/icons_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateTaskController extends GetxController {
  var taskNameTextController = TextEditingController();
  var selectedStartDate = DateTime.now().obs;
  var duration = 0.obs;
  var repeatValue = <int>[].obs;
  var checkCountPerDay = 1.obs;
  var notificationIsOn = false.obs;
  var sloganTextController = TextEditingController();
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
