import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:clock_in/widgets/divider/horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialPicker {
  static void showActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _item("新浪微博", () async {
              if (await canLaunchUrl(
                  Uri(scheme: "https", host: AppStrings.weiboLink))) {
                await launchUrl(Uri(
                    scheme: "https",
                    host: AppStrings.weiboLink,
                    path: "/"));
              } else {
                showToast("无法打开网页");
              }
            }),
            const HorizontalDivider(),
            _item("知乎", () async {
              if (await canLaunchUrl(
                  Uri(scheme: "https", host: AppStrings.zhihuLink))) {
                await launchUrl(Uri(
                    scheme: "https",
                    host: AppStrings.zhihuLink,
                    path: "/"));
              } else {
                showToast("无法打开网页");
              }
            }),
            const HorizontalDivider(),
            _item("小红书", () async {
              if (await canLaunchUrl(
                  Uri(scheme: "https", host: AppStrings.xiaohongshuLink))) {
                await launchUrl(Uri(
                    scheme: "https",
                    host: AppStrings.xiaohongshuLink,
                    path: "/"));
              } else {
                showToast("无法打开网页");
              }
            }),
            SizedBox(height: 20.h)
          ],
        );
      },
    );
  }

  static Widget _item(String title, Function() onTap) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.mainTitle333,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer()
            ],
          ),
        ));
  }
}
