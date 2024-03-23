class TaskModel {
  int? id;

  /// 任务名称
  String? taskName;

  /// 图标
  String? icon;

  /// 计划 1-7, 周一到周日,英文分好隔开(1;2;4;6)
  String? plan;

  ///  持续时间，0:永远
  int? durationDays;

  /// 开始日期
  String? beginDate;

  /// 每日打卡次数,1-24
  int? checkCount;

  /// 提醒时间, 每日可多次打卡,例:0-08:00;1-12:00;2-18:00
  String? remindTime;

  /// 口号
  String? slogan;

  /// 是否开启
  int? isActive;

  /// 创建时间赋值后不更新
  String? createDT;

  /// 更新时间,每次更新都更新
  String? updateDT;

  /// 排序
  int? sort;

  /// 颜色
  String? color;

  /// 打卡记录, 存CheckRecordModel的id,分号隔开,例:1;2;5;66
  String? records;

  /// 只有在取的时候才赋值
  List<CheckRecordModel>? recordsData;

  /// 累计打卡天数
  int? grandTotal;

  /// 最长连续打卡天数
  int? continuousDays;

  /// 本月打卡天数
  int? monthTotal;

  TaskModel({
    this.id,
    this.taskName,
    this.icon,
    this.plan,
    this.durationDays,
    this.beginDate,
    this.checkCount,
    this.remindTime,
    this.slogan,
    this.isActive,
    this.createDT,
    this.updateDT,
    this.sort,
    this.color,
    this.records,
    this.grandTotal,
    this.continuousDays,
    this.monthTotal,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['taskName'];
    icon = json['icon'];
    plan = json['plan'];
    durationDays = json['durationDays'];
    beginDate = json['beginDate'];
    checkCount = json['checkCount'];
    remindTime = json['remindTime'];
    slogan = json['slogan'];
    isActive = json['isActive'];
    createDT = json['createDT'];
    updateDT = json['updateDT'];
    sort = json['sort'];
    color = json['color'];
    records = json['records'];
    grandTotal = json['grandTotal'] ?? 0;
    continuousDays = json['continuousDays'] ?? 0;
    monthTotal = json['monthTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskName'] = taskName;
    data['icon'] = icon;
    data['plan'] = plan;
    data['durationDays'] = durationDays;
    data['beginDate'] = beginDate;
    data['checkCount'] = checkCount;
    data['remindTime'] = remindTime;
    data['slogan'] = slogan;
    data['isActive'] = isActive;
    data['createDT'] = createDT;
    data['updateDT'] = updateDT;
    data['sort'] = sort;
    data['color'] = color;
    data['records'] = records;
    data['grandTotal'] = grandTotal;
    data['continuousDays'] = continuousDays;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class CheckRecordModel {
  int? id;
  // 关联的任务id
  int? taskId;
  // 打卡时间
  String? date;
  // 备注
  String? note;
  // 今日已打卡次数
  int? checkCount;
  String? createDT;
  String? updateDT;

  CheckRecordModel(
      {this.id,
      this.taskId,
      this.date,
      this.note,
      this.checkCount,
      this.createDT,
      this.updateDT});

  CheckRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['taskId'];
    date = json['date'];
    note = json['note'];
    checkCount = json['checkCount'];
    createDT = json['createDT'];
    updateDT = json['updateDT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskId'] = taskId;
    data['date'] = date;
    data['note'] = note;
    data['checkCount'] = checkCount;
    data['createDT'] = createDT;
    data['updateDT'] = updateDT;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
