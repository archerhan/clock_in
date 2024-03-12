import 'dart:io';

import 'package:clock_in/manager/task_dao.dart';
import 'package:clock_in/manager/task_record_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static const _databaseName = "ClockIn.db";
  static const _databaseVersion = 1;

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
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // 创建表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(TaskDao().createTableSql());
    await db.execute(TaskRecordDao().createTableSql());
  }
}
