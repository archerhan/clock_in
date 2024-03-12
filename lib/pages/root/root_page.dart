import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/today/today_page.dart';
import 'package:clock_in/pages/reward/reward_page.dart';
import 'package:clock_in/pages/chart/chart_page.dart';
import 'package:clock_in/pages/root/root_controller.dart';
import 'package:clock_in/pages/setting/setting_page.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      bottomNavigationBar: _bottomNavigationBar(),
      body: Obx(() => IndexedStack(
            index: controller.activeIndex.value,
            children: const [
              TodayPage(),
              // RewardPage(),
              ChartPage(),
              SettingPage()
            ],
          )),
    );
  }

  Widget _bottomNavigationBar() {
    return Obx(() => AnimatedBottomNavigationBar(
          backgroundColor: AppColors.mainWhite,
          shadow: const Shadow(
              color: AppColors.greyCCC, offset: Offset(0, -3), blurRadius: 24),
          safeAreaValues: const SafeAreaValues(bottom: true),
          icons: const [
            CupertinoIcons.today,
            // CupertinoIcons.settings_solid,
            CupertinoIcons.chart_pie,
            CupertinoIcons.settings_solid,
          ],
          iconSize: 40,
          activeColor: AppColors.primaryBlue,
          inactiveColor: AppColors.greyCCC,
          activeIndex: controller.activeIndex.value,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 16,
          rightCornerRadius: 16,
          onTap: (index) {
            SystemSound.play(SystemSoundType.click);
            controller.activeIndex.value = index;
          },
        ));
  }
}
