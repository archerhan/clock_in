import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPicker {
  static void show() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            "请选择社交媒体",
            style: TextStyle(
              color: AppColors.mainTitle333,
              fontSize: 16.sp,
            ),
          ),
          message: Text(
            "请点击对应社交媒体给开发者留言，我会尽快回复您",
            style: TextStyle(
              color: AppColors.subtitle666,
              fontSize: 16.sp,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                "新浪微博",
                style: TextStyle(
                  color: AppColors.mainTitle333,
                  fontSize: 16.sp,
                ),
              ),
              onPressed: () async {
                Get.back();
                final uri = Uri.parse(AppStrings.weiboLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  showToast("无法打开网页");
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                "知乎",
                style: TextStyle(
                  color: AppColors.mainTitle333,
                  fontSize: 16.sp,
                ),
              ),
              onPressed: () async {
                Get.back();
                final uri = Uri.parse(AppStrings.zhihuLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  showToast("无法打开网页");
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                "小红书",
                style: TextStyle(
                  color: AppColors.mainTitle333,
                  fontSize: 16.sp,
                ),
              ),
              onPressed: () async {
                Get.back();
                final uri = Uri.parse(AppStrings.xiaohongshuLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  showToast("无法打开网页");
                }
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              "取消",
              style: TextStyle(
                color: AppColors.mainTitle333,
                fontSize: 16.sp,
              ),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        );
      },
    );
  }
}
