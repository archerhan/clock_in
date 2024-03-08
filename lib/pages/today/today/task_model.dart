class TaskModel {
  int? id;
  // 任务名称
  String? taskName;
  // 图标
  String? icon;
  // 计划 1-1；7-7；x-7;x-30
  String? plan;
  //  持续时间，0:永远
  int? durationDays;
  // 开始日期
  String? beginDate;
  // 每日打卡次数
  int? checkCount;
  // 提醒时间, 每日可多次打卡
  String? remindTime;
  // 口号
  String? slogan;
  // 是否激活
  int? isActive;
  // 创建时间
  String? createDT;
  // 更新时间
  String? updateDT;
  // 排序
  int? sort;
  // 颜色
  String? color;

  TaskModel(
      {this.id,
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
      this.sort,this.color});

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
    return data;
  }
}
