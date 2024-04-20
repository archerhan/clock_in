import 'dart:async';

import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:clock_in/utils/toast_util.dart';
import 'package:flutter/services.dart';
import 'package:icloud_storage/icloud_storage.dart';

class ICloudManager {
  // 单例
  ICloudManager._privateConstructor();
  static final ICloudManager instance = ICloudManager._privateConstructor();

  StreamSubscription? uploadProgressSub;
  StreamSubscription? downloadProgressSub;
  final containerId = "iCloud.com.example.clockin";

  Future<void> uploadData(
      {Function(double)? progress, void Function()? onDone}) async {
    final path = await DBManager.instance.getDatabasePath();
    try {
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
    } catch (e) {
      logger.e("上传失败: $e");
    }
  }

  // 下载数据后存储到备份数据库
  Future downloadData(
      {Function(double)? progress, void Function()? onDone}) async {
    final path = await DBManager.instance.getDatabasePath();
    final backupPath = await DBManager.instance.getBackupDatabasePath();

    try {
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
    } catch (e) {
      // 如果没有备份文件，直接调用 onDone继续往下走
      if ((e as PlatformException).code == "E_NAT") {
        onDone?.call();
      }
      if ((e as PlatformException).code == "E_CTR") {
        showToast("您的iCloud服务暂不可用, 请检查设备的iCloud设置");
      }
      logger.e("下载失败: $e");
    }
  }
}
