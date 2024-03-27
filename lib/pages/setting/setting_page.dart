import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/constants/assets.gen.dart';
import 'package:clock_in/manager/email_manager.dart';
import 'package:clock_in/manager/notification_manager.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/header/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/setting/setting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("设置".tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SectionTitle("数据与安全"),
            _settingGridView([
              _settingItem(Assets.images.common.settingSync.path, "数据备份", () {
                controller.syncData();
              }),
              // _settingItem(
              //     Assets.images.entertainment.entertainmentCards.path, "密码",
              //     () {
              // }),
            ]),
            const SectionTitle("会员"),
            _settingGridView([
              _settingItem(
                  Assets.images.common.settingVip.path, "购买高级版", () {}),
              _settingItem(
                  Assets.images.common.settingRestore.path, "恢复购买", () {}),
            ]),
            const SectionTitle("通用"),
            _settingGridView([
              _settingItem(
                  Assets.images.common.settingLanguage.path, "语言", () {}),
              _settingItem(
                  Assets.images.common.settingNotification.path, "通知", () {}),
              _settingItem(Assets.images.common.settingFeedback.path, "意见反馈",
                  () {
                EmailManager.sendFeedbackEmail();
              }),
              _settingItem(
                  Assets.images.common.settingWebsite.path, "官方网站", () {}),
            ]),
          ],
        ),
      ).paddingSymmetric(horizontal: 20.w),
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
}
