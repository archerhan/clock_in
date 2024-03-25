import 'package:clock_in/manager/notification_manager.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  var activeIndex = 0.obs;

  @override
  void onReady() {
    NotificationManager.instance.requestPermissions();
    NotificationManager.instance.configureSelectNotificationSubject();
    NotificationManager.instance.configureDidReceiveLocalNotificationSubject();
    super.onReady();
  }
}
