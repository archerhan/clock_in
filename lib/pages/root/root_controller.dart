import 'package:clock_in/manager/notification_manager.dart';
import 'package:clock_in/manager/store_manager.dart';
import 'package:clock_in/pages/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootController extends GetxController with WidgetsBindingObserver {
  var activeIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    StoreManager.instance.listenPurchaseUpdates();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void onReady() {
    NotificationManager.instance.requestPermissions();
    NotificationManager.instance.configureSelectNotificationSubject();
    NotificationManager.instance.configureDidReceiveLocalNotificationSubject();
    super.onReady();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        Future.delayed(const Duration(seconds: 1),
            () => Get.find<SettingController>().syncData(showTip: false));
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
