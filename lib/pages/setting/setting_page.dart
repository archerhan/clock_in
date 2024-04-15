import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/manager/email_manager.dart';
import 'package:clock_in/manager/store_manager.dart';
import 'package:clock_in/widgets/dialog/store_bottom_sheet.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/header/section_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/setting/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("设置".tr),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SectionTitle("数据与安全"),
                _settingGridView([
                  if (Platform.isIOS || Platform.isMacOS)
                    FlipCard(
                        frontWidget: _settingItem(
                            Assets.images.common.settingSync.path, "iCloud备份",
                            () {
                          controller.syncDataController.flipcard();
                        }),
                        backWidget: _dataSyncBack(() {
                          controller.syncDataController.flipcard();
                        }),
                        controller: controller.syncDataController,
                        rotateSide: RotateSide.left),
                  _settingItem(
                      Assets.images.common.settingsEmailBackup.path, "备份到邮件",
                      () async {
                    await EmailManager.sendFeedbackEmail(
                        filePath: await DBManager.instance.getDatabasePath());
                  })
                ]),
                const SectionTitle("会员"),
                _settingGridView([
                  _settingItem(Assets.images.common.settingVip.path, "购买高级版",
                      () async {
                    if (StoreManager.instance.hasPurchased) {
                      showToast("您已购买高级版");
                      return;
                    }
                    showLoading();
                    await controller.loadProducts();
                    dismissLoading();
                    final product = StoreManager.instance.products.first;
                    StoreBottomSheet.showStoreOptionsBottomSheet(product.price,
                        () async {
                      showLoading();
                      await StoreManager.instance.purchaseProduct(product);
                      dismissLoading();
                      Navigator.of(Get.context!).pop();
                    });
                  }),
                  _settingItem(Assets.images.common.settingRestore.path, "恢复购买",
                      () async {
                    showLoading();
                    await StoreManager.instance.restorePurchases();
                    showToast("恢复购买成功");
                  }),
                ]),
                const SectionTitle("通用"),
                _settingGridView([
                  FlipCard(
                      frontWidget: _settingItem(
                          Assets.images.common.settingNotification.path, "通知",
                          () {
                        controller.notificationController.flipcard();
                      }),
                      backWidget: _notificationBack(() {
                        controller.notificationController.flipcard();
                      }),
                      controller: controller.notificationController,
                      rotateSide: RotateSide.left),
                  _settingItem(
                      Assets.images.common.settingFeedback.path, "意见反馈", () {
                    EmailManager.sendFeedbackEmail();
                  }),
                  _settingItem(Assets.images.common.settingWebsite.path, "官方网站",
                      () async {
                    if (await canLaunchUrl(
                        Uri(scheme: "http", host: AppStrings.website))) {
                      await launchUrl(
                          Uri(scheme: "http", host: AppStrings.website));
                    } else {
                      showToast("无法打开网页");
                    }
                  }),
                  // _settingItem(
                  //     Assets.images.common.settingAbout.path, "关于", () {}),
                ]),
              ],
            ),
          ).paddingSymmetric(horizontal: 20.w),
          const Spacer(),
          _rights()
        ],
      ),
    );
  }

  Widget _settingGridView(List<Widget> children) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 10,
        crossAxisSpacing: 20,
      ),
      children: children,
    );
  }

  Widget _settingItem(String icon, String title, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: 40.w,
              height: 40.w,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: AppColors.mainTitle333, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataSyncBack(Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    child: AutoSizeText(
                  "自动\n备份",
                  style:
                      TextStyle(color: AppColors.subtitle666, fontSize: 14.sp),
                )),
                Transform.scale(
                  scale: 0.8,
                  child: Obx(() {
                    return CupertinoSwitch(
                      value: controller.isAutoSync.value,
                      onChanged: (value) {
                        Vibrate.feedback(FeedbackType.medium);
                        controller.setAutoSync(value);
                      },
                      activeColor: Colors.green,
                    );
                  }),
                )
              ],
            ),
            // const HorizontalDivider(),
            // Expanded(
            //   child: Row(
            //     children: [
            //       Expanded(
            //           child: Obx(() => _progressItem(
            //                 controller.uploadProgress.value,
            //                 "上传",
            //                 onTap: () => controller.uploadData(),
            //               ))),
            //       Container(
            //         width: 1,
            //         height: double.infinity,
            //         color: AppColors.dividerEEE,
            //       ),
            //       Expanded(
            //           child: Obx(() => _progressItem(
            //               controller.downloadProgress.value, "下载",
            //               onTap: () => controller.downloadData()))),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _notificationBack(Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "允许\n通知",
                  style:
                      TextStyle(color: AppColors.subtitle666, fontSize: 14.sp),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.8,
                  child: Obx(() {
                    return CupertinoSwitch(
                      value: controller.isAllowNotification.value,
                      onChanged: (value) {
                        Vibrate.feedback(FeedbackType.medium);
                        controller.setAllowNotification(value);
                      },
                      activeColor: Colors.green,
                    );
                  }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _progressItem(double progress, String title, {Function()? onTap}) {
  //   return TextButton(
  //       onPressed: onTap,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               SizedBox(
  //                 width: 20.w,
  //                 height: 20.w,
  //                 child: CircularProgressIndicator(
  //                   value: progress,
  //                   valueColor: const AlwaysStoppedAnimation<Color>(
  //                       AppColors.primaryBlue),
  //                   backgroundColor: AppColors.dividerEEE,
  //                 ),
  //               ),
  //               progress == 1
  //                   ? Icon(Icons.check, size: 15.w, color: AppColors.textGreen)
  //                   : Text(
  //                       "${(progress * 100).toInt()}%",
  //                       style: TextStyle(
  //                           color: AppColors.subtitle666, fontSize: 6.sp),
  //                     )
  //             ],
  //           ),
  //           const Spacer(),
  //           Text(
  //             title,
  //             style: TextStyle(color: AppColors.subtitle666, fontSize: 12.sp),
  //           ),
  //         ],
  //       ));
  // }

  Widget _rights() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Text(
        "© 2024 clock_in",
        style: TextStyle(
          color: AppColors.grey999,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
