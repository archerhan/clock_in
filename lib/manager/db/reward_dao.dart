import 'package:clock_in/manager/db/base_dao.dart';
import 'package:clock_in/manager/db/db_manager.dart';
import 'package:clock_in/pages/reward/reward_model.dart';

class RewardDao extends BaseDao {
  @override
  createTableSql() {
    return '''
    CREATE TABLE ${tableName()} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      rewardName TEXT,
      taskId INTEGER,
      taskName TEXT,
      duration INTEGER,
      condition INTEGER,
      icon TEXT,
      beginDate TEXT,
      finishDate TEXT,
      createDT TEXT,
      updateDT TEXT,
      color TEXT
    );
    ''';
  }

  @override
  tableName() {
    return "reward_table";
  }

  // 插入rewardModel
  Future<int> insertReward(RewardModel rewardModel) async {
    var db = await DBManager.instance.database;
    int id = await db.insert(tableName(), rewardModel.toJson());
    return id;
  }

  // 查询所有rewardModel
  Future<List<RewardModel>> queryAllReward() async {
    var db = await DBManager.instance.database;
    List<Map<String, dynamic>> maps = await db.query(tableName());
    return List.generate(maps.length, (i) {
      return RewardModel.fromJson(maps[i]);
    });
  }

}
