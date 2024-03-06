import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/reward/reward_model.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/reward/reward_controller.dart';

class RewardPage extends GetView<RewardController> {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("奖励"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _rewardListView(),
          ],
        ),
      ),
    );
  }

  Widget _rewardListView() {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _rewardItem(controller.rewardList[index]);
          },
          itemCount: controller.rewardList.length,
          itemExtent: 100.h,
        ));
  }

  Widget _rewardItem(RewardModel rewardModel) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: rewardModel.color != null
              ? Color(int.parse(rewardModel.color!, radix: 16)).withOpacity(0.2)
              : AppColors.primaryBlue.withOpacity(0.2),
          // boxShadow: [
          //   BoxShadow(
          //       color: randomColor.withOpacity(0.2),
          //       blurRadius: 5.r,
          //       offset: const Offset(3, 3),
          //       spreadRadius: 1.r)
          // ],
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
