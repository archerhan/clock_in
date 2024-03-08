class TaskRecordModel {
  int? id;
  // 任务名称
  String? taskName;
  // 图标
  String? icon;
  // 口号
  String? slogan;
  // 创建时间
  String? createDT;
  // 备注
  String? note;
  // 奖励id
  int? rewardId;
  // 累计天数
  int? duration;
  // 当前天数
  int? checkCount;
  // 总天数
  int? totalCheckCount;
  // 颜色
  String? color;

  TaskRecordModel(
      {this.id,
      this.taskName,
      this.icon,
      this.slogan,
      this.createDT,
      this.note,
      this.rewardId,
      this.duration,
      this.checkCount,
      this.totalCheckCount,
      this.color});

  TaskRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['taskName'];
    icon = json['icon'];
    slogan = json['slogan'];
    createDT = json['createDT'];
    note = json['note'];
    rewardId = json['rewardId'];
    duration = json['duration'];
    checkCount = json['checkCount'];
    totalCheckCount = json['totalCheckCount'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['taskName'] = taskName;
    data['icon'] = icon;
    data['slogan'] = slogan;
    data['createDT'] = createDT;
    data['note'] = note;
    data['rewardId'] = rewardId;
    data['duration'] = duration;
    data['checkCount'] = checkCount;
    data['totalCheckCount'] = totalCheckCount;
    data['color'] = color;
    return data;
  }
}
