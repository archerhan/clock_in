import 'dart:io';

import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/task_dao.dart';
import 'package:clock_in/utils/logger_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static const _databaseName = "ClockIn.db";
  static const _backupDatabaseName = "ClockInBackup.db";
  static const _databaseVersion = 2;

  DBManager._privateConstructor();
  static final DBManager instance = DBManager._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Database? _backupDatabase;
  Future<Database> get backupDatabase async {
    if (_backupDatabase != null) return _backupDatabase!;
    _backupDatabase = await _initBackupDatabase();
    return _backupDatabase!;
  }

  Future<Database> _initBackupDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _backupDatabaseName);
    logger.d("备份数据库路径:$path");
    final db = await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreateBackup);
    return db;
  }

  // 获取数据库路径
  Future<String> getDatabasePath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return path;
  }

  // 获取备份数据库路径
  Future<String> getBackupDatabasePath() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _backupDatabaseName);
    return path;
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

  // 关闭数据库
  Future closeDb() async {
    var db = await database;
    await db.close();
    _database = null;
  }

  // 关闭备份数据库
  Future closeBackupDb() async {
    var db = await backupDatabase;
    await db.close();
    _backupDatabase = null;
  }
  // 创建表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CheckRecordDao().createTableSql());
    await db.execute(TaskDao().createTableSql());
  }

  // 创建备份数据库的表
  Future<void> _onCreateBackup(Database db, int version) async {
    await db.execute(CheckRecordDao().createTableSql());
    await db.execute(TaskDao().createTableSql());
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
