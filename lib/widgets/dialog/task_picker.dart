import 'package:auto_size_text/auto_size_text.dart';
import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/task_model.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TaskPicker {
  static showTaskPicker(BuildContext context, List<TaskModel> tasks,
      Function(TaskModel) onConfirm) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 256.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "请选择任务",
                  style: TextStyle(
                      color: AppColors.subtitle666,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                const HorizontalDivider(),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.asset(
                          tasks[index].icon ?? "",
                          width: 30,
                          height: 30,
                        ),
                        title: AutoSizeText(
                          tasks[index].taskName ?? "",
                          maxLines: 1,
                          style: TextStyle(
                              color: AppColors.subtitle666, fontSize: 16.sp),
                        ),
                        onTap: () {
                          onConfirm(tasks[index]);
                          Navigator.pop(context);
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const HorizontalDivider(),
                    itemCount: tasks.length,
                  ),
                ),
              ],
            ).paddingSymmetric(vertical: 10.h),
          );
        });
  }
}
