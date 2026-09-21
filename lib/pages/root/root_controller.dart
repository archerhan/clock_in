import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/constants/privacy.dart';
import 'package:clock_in/manager/notification_manager.dart';
import 'package:clock_in/manager/store_manager.dart';
import 'package:clock_in/utils/sp_util.dart';
import 'package:clock_in/widgets/buttons/two_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RootController extends GetxController with WidgetsBindingObserver {
  var activeIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    StoreManager.instance.listenPurchaseUpdates();
    StoreManager.instance.restorePurchases();
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
    showPrivacyDialog();
    super.onReady();
  }

  void showPrivacyDialog() async {
    final isAgreePrivacy = await SPUtil.getBool(AppStrings.isAgreePrivacyLey);

    if (isAgreePrivacy) {
      return;
    }
    Future.delayed(const Duration(seconds: 2), () {
      AwesomeDialog(
        context: Get.context!,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        dismissOnTouchOutside: false,
        body: Column(
          children: [
            SizedBox(
              height: 500.h,
              child: Markdown(
                data: Privacy.privacyMarkdownString,
                onTapLink: (text, href, title) async {
                  if (href?.isNotEmpty == true) {
                    final uri = Uri.parse(href!);
                    if (await canLaunchUrl(uri)) {
                      launchUrl(uri);
                    }
                  }
                },
              ),
            ),
            TwoButtons(
              title1: "不同意",
              title2: "同意",
              onPressed1: () {
                exit(0);
              },
              onPressed2: () {
                SPUtil.save(AppStrings.isAgreePrivacyLey, true);
                Get.back();
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ).show();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
      // 刷新整个应用
      Get.forceAppUpdate();
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
