import 'dart:async';
import 'dart:io';

import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  logger.d('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    logger.d(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class NotificationManager {
  // 单例模式
  // 单例
  NotificationManager._privateConstructor();
  static final NotificationManager instance =
      NotificationManager._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationStream =
      StreamController<ReceivedNotification>.broadcast();
  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();
  final MethodChannel platform =
      const MethodChannel('dexterx.dev/flutter_local_notifications_example');
  final portName = 'notification_send_port';
  String? selectedNotificationPayload;

  /// A notification action which triggers a App navigation event
  final String navigationActionId = 'id_3';

  Future<void> init() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }
    // android 初始化
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // ios/macos初始化设置
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationStream.add(
          ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          ),
        );
      },
      // notificationCategories: darwinNotificationCategories,
    );
    // 初始化设置
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );
    // 初始化
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  // 请求通知权限
  Future<void> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      logger.d(
          'isAndroidGrantedNotificationPermission: $grantedNotificationPermission');
    }
  }

  // 展示通知
  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      logger.d('received notification: $receivedNotification');
    });
  }

  // 选择通知
  void configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      logger.d('selectNotificationStream: $payload');
    });
  }

  // 发送通知
  Future showNotifications() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      subtitle: "subtitle",
      presentBadge: true,
      badgeNumber: 1,
      sound: 'slow_spring_board.aiff',
    );

    NotificationDetails notificationDetails = const NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
      macOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      1,
      'custom sound notification title',
      'custom sound notification body',
      notificationDetails,
      payload: "item x",
    );
  }

  // 计划通知
  Future showScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  // 每周一早上10点
  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future scheduleNotification(TaskModel taskModel) async {
    if (taskModel.remindTime?.isEmpty == true) {
      return;
    }
    final remindTimes = taskModel.remindTime!.split(";");
    for (var element in remindTimes) {
      final title = "快来打卡啦~";
      final subTitle = "${taskModel.taskName ?? ""}任务已经开始";
      final body = taskModel.slogan ?? "";
      final day = int.parse(taskModel.remindTime!.split("-")[0]);
      final time = taskModel.remindTime!.split("-")[1];
      if (day == 0) {
        // 每天提醒
        final scheduledDate = tz.TZDateTime.now(tz.local)
            .add(Duration(hours: int.parse(time.split(":")[0])))
            .add(Duration(minutes: int.parse(time.split(":")[1])));
      } else {
        // 每周x提醒
      }
    }

    // flutterLocalNotificationsPlugin.zonedSchedule(taskModel.id!, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation)
  }

  // 取消通知
  Future<void> cancelNotificationWithTag(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // 关闭通知流
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
