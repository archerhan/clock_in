import 'package:clock_in/manager/base_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';

class TaskDao implements BaseDao {
  @override
  tableName() {
    return 'task_table';
  }

  @override
  createTableSql() {
    return '''
    CREATE TABLE task_table (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskName TEXT,
      icon TEXT,
      plan TEXT,
      durationDays INTEGER,
      beginDate TEXT,
      checkCount INTEGER,
      remindTime TEXT,
      slogan TEXT,
      isActive INTEGER,
      sort INTEGER,
      color TEXT,
      createDT TEXT,
      updateDT TEXT
    )
    ''';
  }

// 插入taskModel
Future<int> insertTask(TaskModel taskModel) async {
  var db = await DBManager.instance.database;
  int id = await db.insert(tableName(), taskModel.toJson());

  // 更新sort字段为id
  Map<String, dynamic> row = {
    'sort' : id,
  };
  await db.update(tableName(), row, where: 'id = ?', whereArgs: [id]);

  return id;
}

  // 查询所有taskModel
  Future<List<TaskModel>> queryAllTask() async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // 查询指定taskModel
  Future<TaskModel?> queryTask(int id) async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps =
        await db.query(tableName(), where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    }
    return null;
  }

  // 更新taskModel
  Future<int> updateTask(TaskModel taskModel) async {
    var db = await DBManager.instance.database;
    return await db.update(tableName(), taskModel.toJson(),
        where: 'id = ?', whereArgs: [taskModel.id]);
  }

  // 删除taskModel
  Future<int> deleteTask(int id) async {
    var db = await DBManager.instance.database;
    return await db.delete(tableName(), where: 'id = ?', whereArgs: [id]);
  }
}
