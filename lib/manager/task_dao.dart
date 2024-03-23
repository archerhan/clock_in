import 'package:clock_in/manager/base_dao.dart';
import 'package:clock_in/manager/db_manager.dart';
import 'package:clock_in/pages/today/today/task_model.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao implements BaseDao {
  @override
  tableName() {
    return 'task_table';
  }

  @override
  createTableSql() {
    return '''
    CREATE TABLE ${tableName()} (
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
      sort INTEGER,
      color TEXT,
      records TEXT,
      grandTotal INTEGER DEFAULT 0,
      continuousDays INTEGER DEFAULT 0
    )
    ''';
  }

// 插入taskModel
  Future<int> insertTask(TaskModel taskModel) async {
    var db = await DBManager.instance.database;
    int id = await db.insert(tableName(), taskModel.toJson());

    // 更新sort字段为id
    Map<String, dynamic> row = {
      'sort': id,
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

  //* 数据备份相关

  // 查询所有的备份taskModel
  Future<List<TaskModel>> queryAllBackupTask() async {
    var db = await DBManager.instance.backupDatabase;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // 将一组taskModel插入数据库
  // 1.将本地的taskModel全部查询出来
  // 2.将待插入的taskModel与本地的taskModel进行比对
  // 3.当待插入的taskModel中有id相同的taskModel时:判断最后更新时间，更新时间晚的taskModel将覆盖数据库中的taskModel, 否则跳过该条数据
  // 4.当待插入的taskModel中有id不同的taskModel时:直接插入数据库
  Future<void> mergeBackupTasks() async {
    // 查询备份数据库中的taskModel
    logger.d("开始合并任务");
    List<TaskModel> backupTaskModels = await queryAllBackupTask();
    logger.d(
        "备份数据库中的任务共计${backupTaskModels.length}条:${backupTaskModels.map((e) => e.taskName).toList()}");
    List<TaskModel> localTaskModels = await queryAllTask();
    logger.d(
        "本地数据库中的任务共计${localTaskModels.length}条:${localTaskModels.map((e) => e.taskName).toList()}");
    for (TaskModel taskModel in backupTaskModels) {
      TaskModel? localTaskModel = localTaskModels.firstWhereOrNull((element) =>
          (element.id == taskModel.id &&
              element.taskName == taskModel.taskName &&
              element.createDT == taskModel.createDT));
      if (localTaskModel == null) {
        logger.d("插入新任务:${taskModel.taskName}");
        await insertTask(taskModel);
      } else {
        logger.d(
            "对比备份任务的更新时间:${taskModel.updateDT}和本地任务的更新时间:${localTaskModel.updateDT}");
        if (DateTime.parse(taskModel.updateDT!)
            .isAfter(DateTime.parse(localTaskModel.updateDT!))) {
          logger.d("更新任务:${taskModel.taskName}");
          await updateTask(taskModel);
        }
      }
    }
    logger.d("任务合并完成");
  }
}
