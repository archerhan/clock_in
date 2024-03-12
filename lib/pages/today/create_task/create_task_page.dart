import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_controller.dart';
import 'package:clock_in/pages/today/create_task/icons_page.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/buttons/ok%20_button.dart';
import 'package:clock_in/widgets/dialog/color_picker.dart';
import 'package:clock_in/widgets/dialog/date_picker.dart';
import 'package:clock_in/widgets/dialog/days_picker.dart';
import 'package:clock_in/widgets/dialog/notification_time_picker.dart';
import 'package:clock_in/widgets/dialog/number_picker.dart';
import 'package:clock_in/widgets/dialog/weekday_select.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:clock_in/widgets/textfield/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';

class CreateTaskPage extends GetView<CreateTaskController> {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("创建任务"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _basicInfo(),
              _notificationInfo(),
              _iconSlogan(),
              OKButton(title: "创建", onPressed: () => controller.createTask())
            ],
          ),
        ),
      ),
    );
  }

  Widget _basicInfo() {
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
      // height: 300.h,
      child: Column(
        children: [
          _inputField(Icons.text_snippet_outlined, "任务名称",
              controller.taskNameTextController),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.today,
                "开始日期",
                DateTimeUtil.formatDate(controller.selectedStartDate.value),
                onTap: () {
                  CustomDatePickerDialog.showDatePicker(
                      Get.context!,
                      (p0) => controller.selectedStartDate.value =
                          p0 ?? DateTime.now());
                },
              )),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.date_range_outlined,
                "持续时间",
                controller.duration.value == 0
                    ? "永远"
                    : "${controller.duration.value}天",
                onTap: () {
                  CustomDaysPickerDialog.showDaysPicker(Get.context!,
                      (p0) => controller.duration.value = p0 ?? 0);
                },
              )),
          const HorizontalDivider(),
          Obx(
            () => _valueSelection(
              Icons.event_repeat_outlined,
              "任务执行日",
              (controller.repeatValue.isEmpty ||
                      controller.repeatValue.length >= 7)
                  ? "每天"
                  : controller.repeatValue
                      .map((e) => DateTimeUtil.getWeekName(e))
                      .join("、"),
              onTap: () {
                WeekdaySelectDialog.showMultiSelect(Get.context!, (p0) {
                  controller.repeatValue.value = p0;
                }, initSelectedValues: controller.repeatValue.toList());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationInfo() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => _valueSelection(
              Icons.checklist_outlined,
              "打卡频率",
              "${controller.checkCountPerDay.value}次/天",
              onTap: () {
                CustomNumberPickerDialog.showCheckCountPicker(Get.context!,
                    (p0) => controller.checkCountPerDay.value = p0 ?? 1);
              },
            ),
          ),
          const HorizontalDivider(),
          Obx(() => _notificationSection(
              controller.notificationIsOn.value ? "通知已开启" : "通知未开启")),
          Obx(() => controller.notificationIsOn.value
              ? const HorizontalDivider()
              : const SizedBox()),
          _notificationTime(),
        ],
      ),
    );
  }

  Widget _iconSlogan() {
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
          _inputField(Icons.sports_mma_outlined, "想一句口号吧!",
              controller.sloganTextController),
          const HorizontalDivider(),
          _colorField(),
          const HorizontalDivider(),
          _iconField(),
        ],
      ),
    );
  }

  Widget _inputField(
      IconData icon, String title, TextEditingController controller) {
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
          ))
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

  Widget _notificationSection(String title) {
    return SizedBox(
      height: 60.h,
      child: Row(
        children: [
          Icon(
            Icons.notification_add_outlined,
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
          const Spacer(),
          Obx(() => controller.notificationIsOn.value
              ? TextButton.icon(
                  onPressed: () {
                    controller.addNotificationTime(
                        controller.initialNotificationTime);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("通知时间"))
              : const SizedBox()),
          Obx(
            () => CupertinoSwitch(
              value: controller.notificationIsOn.value,
              onChanged: (value) {
                Vibrate.feedback(FeedbackType.medium);
                controller.notificationIsOn.value = value;
                if (value) {
                  controller
                      .addNotificationTime(controller.initialNotificationTime);
                } else {
                  controller.notificationTimes.clear();
                }
              },
              activeColor: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  Widget _colorField() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ColorPicker.showColorPicker(
            Get.context!, (p0) => controller.selectedColor.value = p0);
      },
      child: SizedBox(
        height: 60.h,
        child: Row(
          children: [
            Icon(
              Icons.palette_outlined,
              size: 28.w,
              color: AppColors.subtitle666,
            ),
            const SizedBox(width: 8),
            Text(
              "选择卡片背景色",
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Obx(() => controller.selectedColor.value.isNotEmpty == true
                ? CircleAvatar(
                    backgroundColor: Color(int.parse(
                            controller.selectedColor.value,
                            radix: 16))
                        .withOpacity(0.2))
                : const SizedBox()),
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
        Get.to(const IconsPage());
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

  /// 通知时间
  Widget _notificationTime() {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: Obx(
          () => MediaQuery.removePadding(
              removeTop: true,
              removeBottom: true,
              context: Get.context!,
              child: GridView.builder(
                padding: EdgeInsets.symmetric(
                    vertical: controller.notificationIsOn.value ? 10.h : 0),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 4),
                // gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                //     maxCrossAxisExtent: 200, childAspectRatio: 3),
                shrinkWrap: true,
                itemCount: controller.notificationTimes.length,
                itemBuilder: (context, index) {
                  final day = NotificationTimePickerDialog.notificationTuples
                      .firstWhere((day) =>
                          day.item1.toString() ==
                          controller.notificationTimes[index].split("-").first)
                      .item2;
                  final time =
                      controller.notificationTimes[index].split("-").last;
                  return _timeItem("$day $time", index);
                },
              )),
        ));
  }

  Widget _timeItem(String title, int index) {
    return Row(children: [
      // 内容
      GestureDetector(
        onTap: () {
          NotificationTimePickerDialog.showNotificationDayDialog(Get.context!,
              (p0) {
            controller.selectedNotificationTime.value =
                p0 ?? controller.initialNotificationTime;
            controller.notificationTimes[index] =
                p0 ?? controller.initialNotificationTime;
          });
        },
        child: Container(
          height: 28,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: AppColors.subtitle666,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
      // 关闭
      GestureDetector(
        onTap: () {
          controller.removeNotificationTime(index);
        },
        child: Container(
          height: 28,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: const Icon(Icons.close, size: 18),
        ),
      )
    ]);
  }
}
