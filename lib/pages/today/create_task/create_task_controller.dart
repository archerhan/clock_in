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
  var selectedIcon = IconAssetModel().obs;
  var iconList = <IconAssetModel>[].obs;
  @override
  void onInit() {
    loadIcons();
    super.onInit();
  }

  // 加载本地json数据
  Future<void> loadIcons() async {
    String jsonString = await rootBundle.loadString(Assets.json.icons);
    var jsonData = jsonDecode(jsonString);
    var data = <IconAssetModel>[];
    for (var iconPath in jsonData["iconPath"]) {
      data.add(IconAssetModel(assetPath: iconPath, name: ""));
    }
    iconList.value = data;
  }

  void selectIcon(IconAssetModel iconAssetModel) {
    selectedIcon.value = iconAssetModel;
    iconList.value = iconList.map<IconAssetModel>((element) {
      element.isSelected = false;
      if (element.assetPath == iconAssetModel.assetPath) {
        element.isSelected = true;
      }
      return element;
    }).toList();
  }
}
