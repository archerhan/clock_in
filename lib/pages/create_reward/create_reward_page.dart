import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/create_reward/create_reward_controller.dart';
import 'package:clock_in/pages/icons/icons_binding.dart';
import 'package:clock_in/pages/icons/icons_page.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/buttons/ok_button.dart';
import 'package:clock_in/widgets/dialog/date_picker.dart';
import 'package:clock_in/widgets/dialog/target_days_picker.dart';
import 'package:clock_in/widgets/dialog/task_picker.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:clock_in/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateRewardPage extends GetView<CreateRewardController> {
  const CreateRewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text('添加任务奖励'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _info(),
            _buttons(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _info() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ]),
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          _inputField(Icons.star, "奖励内容", controller.rewardNameTextController),
          const HorizontalDivider(),
          Obx(
            () => _valueSelection(
              Icons.task,
              "关联打卡任务",
              controller.selectedTask.value.taskName ?? "",
              onTap: () async {
                final tasks = await TaskDao().queryAllActiveTask();
                if (tasks.isEmpty) {
                  showToast("你还没有创建任务哦, 快去创建一个吧!");
                  return;
                }
                TaskPicker.showTaskPicker(Get.context!, tasks, (p0) {
                  controller.selectedTask.value = p0;
                });
              },
            ),
          ),
          const HorizontalDivider(),
          Obx(
            () => _valueSelection(
              Icons.date_range,
              "目标达成天数",
              "${controller.durationDays.value}天",
              onTap: () {
                TargetDaysPickerDialog.showDaysPicker(Get.context!, (p0) {
                  if (p0 != null) {
                    controller.durationDays.value = p0;
                  }
                });
              },
            ),
          ),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.today,
                "开始日期",
                DateTimeUtil.formatDate(controller.startTime.value),
                onTap: () {
                  CustomDatePickerDialog.showDatePicker(Get.context!,
                      (p0) => controller.startTime.value = p0 ?? DateTime.now(),
                      selected: controller.startTime.value);
                },
              )),
          const HorizontalDivider(),
          _iconField(),
        ],
      ),
    );
  }

  Widget _inputField(
      IconData icon, String title, TextEditingController controller,
      {Function()? action}) {
    return SizedBox(
      height: 60.h,
      child: Row(
        children: [
          Icon(
            icon,
            size: 28.w,
            color: AppColors.subtitle666,
          ),
          const SizedBox(width: 8),
          Expanded(
              child: CustomTextField(
            controller: controller,
            hintText: title,
          )),
          if (action != null)
            TextButton(
                onPressed: action,
                child: Text(
                  "换一句",
                  style:
                      TextStyle(color: AppColors.primaryBlue, fontSize: 12.sp),
                )),
        ],
      ),
    );
  }

  Widget _valueSelection(IconData icon, String title, String selectedValue,
      {Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 60.h,
        child: Row(
          children: [
            Icon(
              icon,
              size: 28.w,
              color: AppColors.subtitle666,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: AutoSizeText(
              selectedValue,
              maxLines: 1,
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            )),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.primaryBlue,
            )
          ],
        ),
      ),
    );
  }

  Widget _iconField() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.to(IconsPage(
          onIconSelected: (p0) {
            controller.selectedIcon.value = p0;
          },
        ), binding: IconsBinding());
      },
      child: SizedBox(
        height: 60.h,
        child: Row(
          children: [
            Icon(
              Icons.sports_mma_outlined,
              size: 28.w,
              color: AppColors.subtitle666,
            ),
            const SizedBox(width: 8),
            Text(
              "选择图标",
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Obx(() => controller.selectedIcon.value.assetPath.isNotEmpty == true
                ? Image.asset(
                    controller.selectedIcon.value.assetPath,
                    width: 30.w,
                    height: 30.w,
                    fit: BoxFit.contain,
                  )
                : SizedBox(width: 30.w, height: 30.w)),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: AppColors.primaryBlue,
            )
          ],
        ),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      children: [
        if (!controller.isCreateReward)
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: OKButton(
                title: "删除",
                onPressed: () {
                  AwesomeDialog(
                    context: Get.context!,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    bodyHeaderDistance: 40.h,
                    dialogType: DialogType.warning,
                    animType: AnimType.bottomSlide,
                    title: "确定要删除任务目标奖励吗?\n",
                    titleTextStyle: TextStyle(
                        color: AppColors.mainTitle333,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                    desc: "删除后将无法恢复, 请谨慎操作!",
                    descTextStyle: TextStyle(
                        color: AppColors.subtitle666, fontSize: 16.sp),
                    btnCancelText: "取消",
                    buttonsTextStyle:
                        TextStyle(color: AppColors.mainWhite, fontSize: 16.sp),
                    btnCancelColor: AppColors.textGreen,
                    btnOkColor: AppColors.textRed,
                    btnOkText: "删除",
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {
                      // await controller.deleteTask();
                      Get.back();
                      showToast("任务已删除!");
                    },
                  ).show();
                },
                backgroundColor: AppColors.warningRed,
              ),
            ),
          ),
        Expanded(
          child: OKButton(title: "完成", onPressed: () {}),
        ),
      ],
    );
  }
}
