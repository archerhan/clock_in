import 'dart:io';

import 'package:clock_in/manager/check_record_dao.dart';
import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static const _databaseName = "ClockIn.db";
  static const _databaseVersion = 2;

  DBManager._privateConstructor();
  static final DBManager instance = DBManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    logger.d("数据库路径:$path");
    final db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
    // addColumnIfNotExists(db, TaskDao().tableName(), columnName, columnType)
    return db;
  }

  // 创建表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(TaskDao().createTableSql());
    await db.execute(CheckRecordDao().createTableSql());
  }

  void addColumnIfNotExists(Database db, String tableName, String columnName,
      String columnType) async {
    // 获取表的信息
    List<Map> columns = await db.rawQuery('PRAGMA table_info($tableName)');

    // 检查字段是否已存在
    bool isExists =
        columns.indexWhere((Map column) => column['name'] == columnName) != -1;

    // 如果字段不存在，添加新的字段
    if (!isExists) {
      await db
          .execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
    }
  }
}
