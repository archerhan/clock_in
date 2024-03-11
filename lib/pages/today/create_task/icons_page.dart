import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/pages/today/create_task/create_task_controller.dart';
import 'package:clock_in/pages/today/create_task/icons_model.dart';
import 'package:clock_in/widgets/appbar/custom_appbar.dart';
import 'package:clock_in/widgets/header/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

class IconsPage extends GetView<CreateTaskController> {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: const Text("选择图标"),
      ),
      body: _iconCategoryList(),
    );
  }

  Widget _iconCategoryList() {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.iconList.length,
          itemBuilder: (_, index) {
            return _iconGridView(controller.iconList[index]);
          },
        ));
  }

  Widget _iconGridView(IconCategoryModel iconCategoryModel) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3))
          ]),
      child: Column(
        children: [
          SectionTitle(controller.getCategoryNameBy(iconCategoryModel.category))
              .paddingSymmetric(horizontal: 10.w),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5),
            itemBuilder: (_, index) {
              return _iconItem(iconCategoryModel.iconAssets[index]);
            },
            itemCount: iconCategoryModel.iconAssets.length,
          )
        ],
      ),
    );
  }

  Widget _iconItem(IconAssetModel iconAssetModel) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            controller.selectIcon(iconAssetModel);
            Get.back();
          },
          child: Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
                color: iconAssetModel.isSelected == true
                    ? AppColors.primaryYellow.withOpacity(0.7)
                    : AppColors.mainWhite,
                borderRadius: BorderRadius.circular(8.r)),
            child: iconAssetModel.assetPath?.isNotEmpty == true
                ? Image.asset(
                    iconAssetModel.assetPath!,
                    width: 50.w,
                    height: 50.w,
                    fit: BoxFit.contain,
                  )
                : SizedBox(
                    width: 50.w,
                    height: 50.w,
                  ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
