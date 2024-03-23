import 'dart:async';

import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:icloud_storage/icloud_storage.dart';

class ICloudManager {
  // 单例
  ICloudManager._privateConstructor();
  static final ICloudManager instance = ICloudManager._privateConstructor();

  StreamSubscription? uploadProgressSub;
  StreamSubscription? downloadProgressSub;
  final containerId = "iCloud.fun.4coding.clockIn";

  Future<void> uploadData(
      {Function(double)? progress, void Function()? onDone}) async {
    final path = await DBManager.instance.getDatabasePath();
    await ICloudStorage.upload(
      containerId: containerId,
      filePath: path,
      onProgress: (stream) {
        uploadProgressSub = stream.listen(
          progress,
          onDone: onDone,
          onError: (err) {
            showToast("上传失败: ${err.toString()}");
          },
          cancelOnError: true,
        );
      },
    );
  }

  // 下载数据后存储到备份数据库
  Future downloadData(
      {Function(double)? progress, void Function()? onDone}) async {
    final path = await DBManager.instance.getDatabasePath();
    final backupPath = await DBManager.instance.getBackupDatabasePath();
    await ICloudStorage.download(
      containerId: containerId,
      relativePath: path.split("/").last,
      destinationFilePath: backupPath,
      onProgress: (stream) {
        downloadProgressSub = stream.listen(
          progress,
          onDone: onDone,
          onError: (err) {
            showToast("下载失败: ${err.toString()}");
          },
          cancelOnError: true,
        );
      },
    );
  }
}
