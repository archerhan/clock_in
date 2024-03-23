import 'dart:async';

import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/manager/icloud_manager.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/pages/today/today/today_controller.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  var downloadProgress = 0.0.obs;
  var uploadProgress = 0.0.obs;

  /// 同步数据
  Future syncData() async {
    await ICloudManager.instance.downloadData(
        progress: (progress) => downloadProgress.value = progress,
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
          await ICloudManager.instance.uploadData(
            progress: (p0) => uploadProgress.value = p0,
            onDone: () {
              showToast("同步成功");
            },
          );
        });
  }
}
