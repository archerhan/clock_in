import 'dart:convert';

import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/pages/icons/icons_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IconsController extends GetxController {
  // 图标列表
  var iconList = <IconCategoryModel>[].obs;
  var selectedIcon = IconAssetModel("", false).obs;


  @override
  void onReady() {
    loadIcons();
    super.onReady();
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

  // // 选择图标
  // void selectIcon(IconAssetModel iconAssetModel) {
  //   selectedIcon.value = iconAssetModel;
  //   for (var category in iconList) {
  //     for (var icon in category.iconAssets) {
  //       icon.isSelected = false;
  //       if (icon.assetPath == iconAssetModel.assetPath) {
  //         icon.isSelected = true;
  //       }
  //     }
  //   }
  //   iconList.refresh();
  // }

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
}
