import 'package:clock_in/manager/db/base_dao.dart';
import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';

class CheckRecordDao extends BaseDao {
  @override
  createTableSql() {
    String createTableQuery = '''
    CREATE TABLE ${tableName()} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskId INTEGER,
      date TEXT,
      note TEXT,
      checkCount INTEGER DEFAULT 0,
      createDT TEXT,
      updateDT TEXT
    )
    ''';
    return createTableQuery;
  }

  @override
  tableName() {
    return 'check_record_table';
  }

  // 插入checkRecordModel
  Future<int> insertCheckRecord(CheckRecordModel checkRecordModel) async {
    var db = await DBManager.instance.database;
    return await db.insert(tableName(), checkRecordModel.toJson());
  }

  // 查询所有checkRecordModel
  Future<List<CheckRecordModel>> queryAllCheckRecords() async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return CheckRecordModel.fromJson(maps[i]);
    });
  }

  // 查询指定checkRecordModel
  Future<CheckRecordModel?> queryCheckRecord(int id) async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query(tableName(), where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return CheckRecordModel.fromJson(maps.first);
    }
    return null;
  }

  // 查询指定taskId和date的checkRecordModel
  Future<CheckRecordModel?> queryCheckRecordByDate(
      int taskId, DateTime date) async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName(),
        where: 'taskId = ? and date = ?',
        whereArgs: [taskId, date.toString().split(' ')[0]]);
    if (maps.isNotEmpty) {
      return CheckRecordModel.fromJson(maps.first);
    }
    return null;
  }

  Future<int> queryCheckCountByTaskId(int taskId) async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName(),
        columns: ['SUM(checkCount) as checkCount'],
        where: 'taskId = ?',
        whereArgs: [taskId]);
    if (maps.isNotEmpty) {
      return maps.first['checkCount'] as int;
    }
    return 0;
  }

  // 更新checkRecordModel
  Future<int> updateCheckRecord(CheckRecordModel checkRecordModel) async {
    var db = await DBManager.instance.database;
    return await db.update(tableName(), checkRecordModel.toJson(),
        where: 'id = ?', whereArgs: [checkRecordModel.id]);
  }

  // 删除checkRecordModel
  Future<int> deleteCheckRecord(int id) async {
    var db = await DBManager.instance.database;
    return await db.delete(tableName(), where: 'id = ?', whereArgs: [id]);
  }

  // 删除指定taskId的所有checkRecordModel
  Future<int> deleteCheckRecordByTaskId(int taskId) async {
    var db = await DBManager.instance.database;
    return await db
        .delete(tableName(), where: 'taskId = ?', whereArgs: [taskId]);
  }

  //* 数据备份相关
  // 查询所有的备份checkRecordModel
  Future<List<CheckRecordModel>> queryAllBackupCheckRecord() async {
    var db = await DBManager.instance.backupDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return CheckRecordModel.fromJson(maps[i]);
    });
  }

  // 将一组checkRecordModel插入数据库
  // 1.将本地的checkRecordModel全部查询出来
  // 2.将待插入的checkRecordModel与本地的checkRecordModel进行比对
  // 3.当待插入的checkRecordModel中有id相同的checkRecordModel时:判断最后更新时间，更新时间晚的checkRecordModel将覆盖数据库中的checkRecordModel, 否则跳过该条数据
  // 4.当待插入的checkRecordModel中有id不同的taskModel时:直接插入数据库
  Future<void> mergeBackupCheckRecords() async {
    logger.d("开始合并打卡记录");
    List<CheckRecordModel> backupCheckRecordModels =
        await queryAllBackupCheckRecord();
    logger.d(
        "备份数据库中的打卡记录共计${backupCheckRecordModels.length}条:${backupCheckRecordModels.map((e) => e.date).toList()}");
    var db = await DBManager.instance.database;
    List<CheckRecordModel> localCheckRecordModels =
        await queryAllCheckRecords();
    logger.d(
        "本地数据库中的打卡记录共计${localCheckRecordModels.length}条:${localCheckRecordModels.map((e) => e.date).toList()}");
    for (CheckRecordModel recordModel in backupCheckRecordModels) {
      CheckRecordModel? localCheckRecordModel = localCheckRecordModels
          .firstWhereOrNull((element) => (element.id == recordModel.id &&
              element.taskId == recordModel.taskId &&
              element.createDT == recordModel.createDT));
      if (localCheckRecordModel == null) {
        logger.d("插入新打卡记录:${recordModel.toJson()}");
        await db.insert(tableName(), recordModel.toJson());
      } else {
        logger.d(
            "对比备份打卡记录的更新时间:${recordModel.updateDT}和本地打卡记录的更新时间:${recordModel.updateDT}");
        if (DateTime.parse(recordModel.updateDT!)
            .isAfter(DateTime.parse(localCheckRecordModel.updateDT!))) {
          logger.d("更新打卡记录:${recordModel.toJson()}");
          await db.update(tableName(), recordModel.toJson(),
              where: 'id = ?', whereArgs: [recordModel.id]);
        }
      }
    }
    logger.d("打卡记录合并完成");
  }
}
