import 'dart:io';

import 'package:clock_in/manager/db/check_record_dao.dart';
import 'package:clock_in/manager/db/reward_dao.dart';
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
  // 同时缓存打开中的 Future, 避免并发调用时重复 openDatabase
  // (旧实现里多个页面同时取 database 会各自打开一次连接, 造成连接泄漏)
  static Future<Database>? _databaseFuture;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _databaseFuture ??= _initDatabase();
    try {
      _database = await _databaseFuture;
      return _database!;
    } catch (e) {
      // 打开失败时允许下次重试
      _databaseFuture = null;
      rethrow;
    }
  }

  static Database? _backupDatabase;
  static Future<Database>? _backupDatabaseFuture;

  Future<Database> get backupDatabase async {
    if (_backupDatabase != null) return _backupDatabase!;
    _backupDatabaseFuture ??= _initBackupDatabase();
    try {
      _backupDatabase = await _backupDatabaseFuture;
      return _backupDatabase!;
    } catch (e) {
      _backupDatabaseFuture = null;
      rethrow;
    }
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

  Future<Database> _initDatabase() async {
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
    _databaseFuture = null;
  }

  // 关闭备份数据库
  Future closeBackupDb() async {
    var db = await backupDatabase;
    await db.close();
    _backupDatabase = null;
    _backupDatabaseFuture = null;
  }

  // 创建表
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(CheckRecordDao().createTableSql());
    await db.execute(TaskDao().createTableSql());
    await db.execute(RewardDao().createTableSql());
  }

  // 创建备份数据库的表
  Future<void> _onCreateBackup(Database db, int version) async {
    await db.execute(CheckRecordDao().createTableSql());
    await db.execute(TaskDao().createTableSql());
    await db.execute(RewardDao().createTableSql());
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
