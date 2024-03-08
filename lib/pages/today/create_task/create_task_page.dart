import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_controller.dart';
import 'package:clock_in/utils/datetime_util.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/date_picker/date_picker_view.dart';
import 'package:clock_in/widgets/dialog/date_picker_dialog.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:clock_in/widgets/textfield/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateTaskPage extends GetView<CreateTaskController> {
  const CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("创建任务"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              _basicInfo(),
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
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      // height: 300.h,
      child: Column(
        children: [
          _inputField(Icons.text_snippet_outlined, "任务名称"),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.today,
                "开始日期",
                DateTimeUtil.formatDate(controller.selectedStartDate.value),
                onTap: () {
                  showCustomDateTimeDialog(
                      showType: DatePickerShowType.ymd,
                      onOKTap: (date) {
                        controller.selectedStartDate.value =
                            DateTime.parse(date);
                      });
                },
              )),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.date_range_outlined,
                "持续时间",
                "${controller.duration.value}天",
                onTap: () {
                  showCustomDateTimeDialog(
                      showType: DatePickerShowType.ymd,
                      onOKTap: (date) {
                        controller.selectedStartDate.value =
                            DateTime.parse(date);
                      });
                },
              )),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.event_repeat_outlined,
                "重复",
                controller.repeatValue.value,
                onTap: () {
                  showCustomDateTimeDialog(
                      showType: DatePickerShowType.ymd,
                      onOKTap: (date) {
                        controller.selectedStartDate.value =
                            DateTime.parse(date);
                      });
                },
              )),
          const HorizontalDivider(),
          Obx(() => _valueSelection(
                Icons.checklist_outlined,
                "打卡频率",
                controller.checkCountPerDay.value.toString(),
                onTap: () {
                  showCustomDateTimeDialog(
                      showType: DatePickerShowType.ymd,
                      onOKTap: (date) {
                        controller.selectedStartDate.value =
                            DateTime.parse(date);
                      });
                },
              )),
        ],
      ),
    );
  }

  Widget _inputField(IconData icon, String title) {
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
            controller: controller.taskNameTextController,
            hintText: title,
          ))
        ],
      ),
    );
  }

  Widget _valueSelection(IconData icon, String title, String selectedValue,
      {Function()? onTap}) {
    return GestureDetector(
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
            const Spacer(),
            Text(
              selectedValue,
              style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            ),
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
}
