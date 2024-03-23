import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:get/get.dart';
import 'package:icloud_storage/icloud_storage.dart';

class ICloudManager {
  // 单例
  ICloudManager._privateConstructor();
  static final ICloudManager instance = ICloudManager._privateConstructor();

  late String filePath;
  late String backupFilePath;

  StreamSubscription? uploadProgressSub;
  StreamSubscription? downloadProgressSub;
  final containerId = 'iCloud.fun.4coding.clockIn';

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
            AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.error,
              title: '上传失败',
              desc: err.toString(),
            ).show();
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

    await ICloudStorage.download(
      containerId: containerId,
      relativePath: path.split("/").last,
      destinationFilePath: backupFilePath,
      onProgress: (stream) {
        downloadProgressSub = stream.listen(
          progress,
          onDone: onDone,
          onError: (err) {
            AwesomeDialog(
              context: Get.context!,
              dialogType: DialogType.error,
              title: '下载失败',
              desc: err.toString(),
            ).show();
          },
          cancelOnError: true,
        );
      },
    );
  }
}
