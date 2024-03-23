import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:clock_in/manager/check_record_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/manager/icloud_manager.dart';
import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  // 备份数据
  Future backupData() async {
    ICloudManager.instance.uploadData(
      onDone: () {
        BotToast.showText(text: '备份成功');
      },
    );
  }

  // 恢复数据
  Future restoreData() async {
    await ICloudManager.instance.downloadData(progress: (progress) {
      logger.d('下载进度: $progress');
    }, onDone: () async {
      await DBManager.instance.closeBackupDb();

      await TaskDao().mergeBackupTasks();
      await CheckRecordDao().mergeBackupTasks();

      Get.find<TodayController>().loadData();
      BotToast.showText(text: '恢复成功');
    });
  }
}
