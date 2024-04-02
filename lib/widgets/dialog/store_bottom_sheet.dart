import 'dart:async';

import 'package:clock_in/constants/app_colors.dart';
import 'package:clock_in/constants/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intro_slider/intro_slider.dart';

class StoreBottomSheet {
  static const double _imageHeight = 100.0;
  // 显示商店选项底部弹窗
  static Future showStoreOptionsBottomSheet() async {
    await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: IntroSlider(
                key: UniqueKey(),
                isShowDoneBtn: false,
                isShowNextBtn: false,
                isShowSkipBtn: false,
                isShowPrevBtn: false,
                listContentConfig: [
                  ContentConfig(
                    title: "无限任务添加",
                    description: "免费版只能添加3个任务, 高级版不限制任务数量",
                    pathImage: Assets.images.common.settingVip.path,
                    heightImage: _imageHeight,
                    foregroundImageFit: BoxFit.contain,
                    backgroundColor: Colors.amber,
                  ),
                  ContentConfig(
                    title: "云同步",
                    description: "免费版数据只能存于本地, 高级版可以通过iCloud同步数据",
                    pathImage: Assets.images.common.settingSync.path,
                    heightImage: _imageHeight,
                    foregroundImageFit: BoxFit.contain,
                    backgroundColor: Colors.deepOrange,
                  ),
                  ContentConfig(
                    title: "多次提醒",
                    description: "免费版每个任务最多提醒2次, 高级版不限制",
                    pathImage: Assets.images.common.settingNotification.path,
                    heightImage: _imageHeight,
                    foregroundImageFit: BoxFit.contain,
                    backgroundColor: Colors.lime,
                  ),
                  ContentConfig(
                    title: "支持开发者",
                    description: "您的支持是我更新的动力",
                    pathImage: Assets.images.others.othersGuitar.path,
                    heightImage: _imageHeight,
                    foregroundImageFit: BoxFit.contain,
                    backgroundColor: Colors.indigo,
                  )
                ],
              )),
              SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: const Text("永久购买高级版￥12.00"),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "购买后可永久使用高级版功能, 无需再次购买\n高级版将和您的Apple ID绑定, 可在其他设备上恢复购买",
                      style:
                          TextStyle(color: AppColors.grey999, fontSize: 12.sp),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
