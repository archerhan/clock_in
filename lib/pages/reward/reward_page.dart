import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/manager/db/reward_dao.dart';
import 'package:clock_in/manager/store_manager.dart';
import 'package:clock_in/pages/create_reward/create_reward_binding.dart';
import 'package:clock_in/pages/create_reward/create_reward_page.dart';
import 'package:clock_in/pages/reward/reward_model.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:clock_in/pages/reward/reward_controller.dart';

class RewardPage extends GetView<RewardController> {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("奖励"),
        actions: [
          IconButton(
            onPressed: () async {
              if (StoreManager.instance.hasPurchased == false &&
                  (await RewardDao().queryAllReward()).length >= 3) {
                showToast("免费版最多只能创建3个任务奖励");
                return;
              }
              Get.to(const CreateRewardPage(), binding: CreateRewardBinding())
                  ?.then((value) {
                controller.loadAllRewards();
              });
            },
            icon: Icon(
              Icons.add,
              size: 30.w,
            ),
          ),
          const SizedBox(width: 10)
        ],
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
          itemExtent: 160.h,
        ).paddingSymmetric(horizontal: 20, vertical: 10));
  }

  Widget _rewardItem(RewardModel rewardModel) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: rewardModel.color != null
              ? Color(int.parse(rewardModel.color!, radix: 16)).withOpacity(0.2)
              : AppColors.primaryBlue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (rewardModel.icon?.isNotEmpty == true)
                  Image.asset(
                    rewardModel.icon!,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.contain,
                  ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rewardModel.rewardName!,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    RichText(
                        text: TextSpan(
                            text: rewardModel.taskName,
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold),
                            children: [
                          TextSpan(
                            text: "已坚持",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey999,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "${rewardModel.duration}",
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: AppColors.grey999,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "/${rewardModel.condition}天",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.grey999,
                                fontWeight: FontWeight.bold),
                          ),
                        ])),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.mainWhite,
                    value: rewardModel.duration! / rewardModel.condition!,
                    color: AppColors.textGreen,
                    minHeight: 10.h,
                    borderRadius: BorderRadius.all(Radius.circular(5.h)),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 50.w,
                  child: Text(
                    "${(rewardModel.duration! / rewardModel.condition! * 100).toStringAsFixed(0)}%",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey999,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
