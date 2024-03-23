import 'package:clock_in/manager/base_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/pages/today/today/task_model.dart';

class CheckRecordDao extends BaseDao {
  @override
  createTableSql() {
    String createTableQuery = '''
    CREATE TABLE ${tableName()} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskId INTEGER,
      date TEXT,
      note TEXT,
      checkCount INTEGER DEFAULT 0
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
  Future<CheckRecordModel?> queryCheckRecordByDate(int taskId, DateTime date) async {
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
}
