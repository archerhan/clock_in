import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateTaskController extends GetxController{
  var taskNameTextController = TextEditingController();
  var selectedStartDate = DateTime.now().obs;
  var duration = 0.obs;
  var repeatValue = "1-1".obs;
  var checkCountPerDay = 1.obs;
  @override
  void onInit() {

    super.onInit();
  }
}