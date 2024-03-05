import 'package:clock_in/manager/base_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/pages/today/task_model.dart';

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
      createDT TEXT,
      updateDT TEXT,
      sort INTEGER
    )
    ''';
  }
  // 插入taskModel
  Future<int> insertTask(TaskModel taskModel) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.insert(tableName(), taskModel.toJson());
  }

  // 查询所有taskModel
  Future<List<TaskModel>> queryAllTask() async {
    var db = await DBManager.getInstance().getDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // 查询指定taskModel
  Future<TaskModel?> queryTask(int id) async {
    var db = await DBManager.getInstance().getDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName(), where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    }
    return null;
  }

  // 更新taskModel
  Future<int> updateTask(TaskModel taskModel) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.update(tableName(), taskModel.toJson(), where: 'id = ?', whereArgs: [taskModel.id]);
  }

  // 删除taskModel
  Future<int> deleteTask(int id) async {
    var db = await DBManager.getInstance().getDatabase;
    return await db.delete(tableName(), where: 'id = ?', whereArgs: [id]);
  }

}
