import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showToast(String content, {bool isShowCenter = true}) {
  BotToast.showText(
      text: content,
      align: isShowCenter ? Alignment.center : const Alignment(0, 0.7),
      animationDuration: const Duration(milliseconds: 100),
      textStyle: TextStyle(fontSize: 15.sp, color: Colors.white),
      contentColor: Colors.black,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
      borderRadius: BorderRadius.circular(20.w));
}

CancelFunc showLoading({
  BackButtonBehavior backButtonBehavior = BackButtonBehavior.close,
  bool crossPage = true,
  bool clickClose = false,
  bool allowClick = false,
  int duration = 30,
  VoidCallback? onClose,
}) {
  return BotToast.showLoading(
      duration: duration == -1 ? null : Duration(seconds: duration),
      onClose: () {
        if (onClose != null) onClose();
      },
      backButtonBehavior: backButtonBehavior,
      backgroundColor: Colors.transparent);
}

void dismissLoading() {
  BotToast.closeAllLoading();
}

void showTopSnack(String? content) {
  BotToast.showCustomNotification(
    toastBuilder: (cancelFunc) {
      return SafeArea(
        child: Container(
          width: 1.sw,
          margin: EdgeInsets.all(10.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(4.w),
          ),
          child: GestureDetector(
            onTap: () {
              cancelFunc.call();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    content!,
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    crossPage: true,
    enableKeyboardSafeArea: true,
    duration: const Duration(seconds: 5),
  );
}
