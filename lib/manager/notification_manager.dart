import 'dart:async';
import 'dart:io';

import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

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
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

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
            badge: false,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: false,
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

  // 每天定时提醒
  tz.TZDateTime _scheduleDaily(String time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
    return scheduledDate;
  }

  // 每周x定时提醒
  tz.TZDateTime _scheduleWeekly(String time, int day) {
    var scheduledDate = _scheduleDaily(time);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 定时提醒
  Future scheduleNotification(TaskModel taskModel) async {
    if (taskModel.remindTime?.isEmpty == true) {
      return;
    }

    cancelNotificationByTask(taskModel);

    final remindTimes = taskModel.remindTime!.split(";");
    for (var element in remindTimes) {
      const title = "快来打卡啦👋";
      final subTitle = "⏰${taskModel.taskName ?? ""}任务已经开始";
      final body = "${taskModel.slogan ?? ""}💪🏻💪🏻💪🏻";
      final day = int.parse(element.split("-")[0]);
      final time = element.split("-")[1];
      var scheduledDate = tz.TZDateTime.now(tz.local);
      final DateTimeComponents? components;
      if (day == 0) {
        // 每天提醒
        scheduledDate = _scheduleDaily(time);
        components = DateTimeComponents.time;
      } else {
        // 每周x提醒
        scheduledDate = _scheduleWeekly(time, day);
        components = DateTimeComponents.dayOfWeekAndTime;
      }
      final id = taskModel.id! * 100000 +
          day * 10000 +
          int.parse(time.split(":")[0]) * 100 +
          int.parse(time.split(":")[1]);
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          "$subTitle\n$body",
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notificationdescription',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: components,
        );
        logger.d("已设置通知id：$id, 时间为: $scheduledDate");
      } catch (e) {
        logger.e("设置通知失败: $e");
      }
    }
    final notifiList =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger.d("通知池中通知：${notifiList.map((e) => e.id).toList()}");
  }

  // 按照任务id取消通知
  Future<void> cancelNotificationByTask(TaskModel taskModel) async {
    final notifiList =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger.d("通知池中通知：${notifiList.map((e) => e.id).toList()}");
    for (var element in notifiList) {
      if (element.id ~/ 100000 == taskModel.id) {
        cancelNotificationWithId(element.id);
      }
    }
    final notifiListLeft =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger.d("取消后通知池中剩余通知：${notifiListLeft.map((e) => e.id).toList()}");
  }

  Future cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    final notifiList =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger.d("取消后通知池中剩余通知：${notifiList.map((e) => e.id).toList()}");
  }

  Future scheduleAllNotification() async {
    final taskList = await TaskDao().queryAllTask();
    for (var element in taskList) {
      if (element.isActive == 1) {
        await scheduleNotification(element);
      }
    }
    final notifiList =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    logger.d("全部打开后通知池的通知：${notifiList.map((e) => e.id).toList()}");
  }

  // 取消通知
  Future<void> cancelNotificationWithId(int id) async {
    logger.d("取消通知id：$id");
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
