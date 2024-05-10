import 'package:clock_in/pages/icons/icons_model.dart';
import 'package:clock_in/pages/today/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRewardController extends GetxController {
  var isCreateReward = false;
  final rewardNameTextController = TextEditingController();
  var selectedTask = TaskModel().obs;
  var durationDays = 1.obs;
  var startTime = DateTime.now().obs;
  var selectedIcon = IconAssetModel("", false).obs;
}
