import 'package:clock_in/manager/base_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/pages/today/today/task_record_model.dart';

class TaskRecordDao extends BaseDao {
  @override
  createTableSql() {
    String createTableQuery = '''
    CREATE TABLE taskRecords (
      taskName TEXT,
      createDT TEXT,
      note TEXT,
      rewardId INTEGER,
      duration INTEGER,
      checkCount INTEGER,
      totalCheckCount INTEGER
    )
    ''';
    return createTableQuery;
  }

  @override
  tableName() {
    return 'task_records_table';
  }

  // 插入taskRecordModel
  Future<int> insertTaskRecord(TaskRecordModel taskRecordModel) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.insert(tableName(), taskRecordModel.toJson());
  }

  // 查询所有taskRecordModel
  Future<List<TaskRecordModel>> queryAllTaskRecord() async {
    var db = await DBManager.getInstance().getDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return TaskRecordModel.fromJson(maps[i]);
    });
  }

  // 查询指定taskRecordModel
  Future<TaskRecordModel?> queryTaskRecord(int id) async {
    var db = await DBManager.getInstance().getDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName(), where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskRecordModel.fromJson(maps.first);
    }
    return null;
  }

  // 更新taskRecordModel
  Future<int> updateTaskRecord(TaskRecordModel taskRecordModel) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.update(tableName(), taskRecordModel.toJson(), where: 'id = ?', whereArgs: [taskRecordModel.id]);
  }

  // 删除taskRecordModel
  Future<int> deleteTaskRecord(int id) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.delete(tableName(), where: 'id = ?', whereArgs: [id]);
  }

}
