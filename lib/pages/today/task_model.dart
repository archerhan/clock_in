class TaskModel {
  int? id;
  String? taskName;
  String? icon;
  String? plan;
  int? durationDays;
  String? beginDate;
  int? checkCount;
  String? remindTime;
  String? slogan;
  int? isActive;
  String? createDT;
  String? updateDT;
  int? sort;

  TaskModel(
      {
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
      this.sort});

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
    return data;
  }
}
