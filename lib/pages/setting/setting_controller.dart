import 'dart:async';

import 'package:clock_in/constants/app_strings.dart';
import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/manager/icloud_manager.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';
import 'package:clock_in/utils/sp_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var downloadProgress = 0.0.obs;
  var uploadProgress = 0.0.obs;

  // 是否开启自动同步
  var isAutoSync = true.obs;
  // 是否允许通知
  var isAllowNotification = true.obs;

  var syncDataController = FlipCardController();
  var vipController = FlipCardController();
  var notificationController = FlipCardController();

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  Future initData() async {
    isAutoSync.value =
        await SPUtil.getBool(AppStrings.autoSyncDataKey, defaultValue: true);
    isAllowNotification.value = await SPUtil.getBool(
        AppStrings.allowNotificationKey,
        defaultValue: true);
  }

  Future setAutoSync(bool value) async {
    isAutoSync.value = value;
    await SPUtil.save(AppStrings.autoSyncDataKey, value);
  }

  Future setAllowNotification(bool value) async {
    isAllowNotification.value = value;
    await SPUtil.save(AppStrings.allowNotificationKey, value);
  }

  Future uploadData() async {
    try {
      uploadProgress.value = 0;
      await ICloudManager.instance.uploadData(
        progress: (p0) =>
            uploadProgress.value = double.parse((p0 / 100).toStringAsFixed(2)),
        onDone: () {
          showToast("备份成功");
        },
      );
    } catch (e) {
      showToast("备份失败");
    }
  }

  Future downloadData() async {
    try {
      downloadProgress.value = 0;
      await ICloudManager.instance.downloadData(
          progress: (p0) => downloadProgress.value =
              double.parse((p0 / 100).toStringAsFixed(2)),
          onDone: () async {
            // 关闭现有的备份数据库, 以防读取不到现在的数据
            await DBManager.instance.closeBackupDb();
            // 合并任务数据
            await TaskDao().mergeBackupTasks();
            // 合并打卡数据
            await CheckRecordDao().mergeBackupCheckRecords();
            // 重新加载数据
            Get.find<TodayController>().loadData();
            showToast("恢复成功");
          });
    } catch (e) {
      showToast("恢复失败");
    }
  }

  /// 同步数据
  Future syncData({bool showTip = true}) async {
    try {
      downloadProgress.value = 0;
      await ICloudManager.instance.downloadData(
          progress: (progress) => downloadProgress.value =
              double.parse((progress / 100).toStringAsFixed(2)),
          onDone: () async {
            // 关闭现有的备份数据库, 以防读取不到现在的数据
            await DBManager.instance.closeBackupDb();
            // 合并任务数据
            await TaskDao().mergeBackupTasks();
            // 合并打卡数据
            await CheckRecordDao().mergeBackupCheckRecords();
            // 重新加载数据
            Get.find<TodayController>().loadData();
            // 上传合并后的数据
            uploadProgress.value = 0;
            await ICloudManager.instance.uploadData(
              progress: (p0) => uploadProgress.value =
                  double.parse((p0 / 100).toStringAsFixed(2)),
              onDone: () {
                if (showTip) {
                  showToast("同步成功");
                }
              },
            );
          });
    } catch (e) {
      if (showTip) {
        showToast("同步失败");
      }
    }
  }
}
