import 'dart:async';
import 'dart:io';

import 'package:clock_in/utils/logger_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  logger.d('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
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

  /// A notification action which triggers a url launch event
  final String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  final String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  final String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  final String darwinNotificationCategoryPlain = 'plainCategory';

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
    // ios/macos通知分类
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

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
      notificationCategories: darwinNotificationCategories,
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

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }

  Future<void> _cancelNotificationWithTag() async {
    await flutterLocalNotificationsPlugin.cancel(1, tag: 'tag');
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
