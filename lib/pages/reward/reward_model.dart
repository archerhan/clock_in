class RewardModel {
  int? id;
  String? rewardName;
  int? taskId;
  String? taskName;
  int? duration;
  int? condition;
  String? icon;
  String? beginDate;
  String? finishDate;
  String? createDT;
  String? updateDT;
  String? color;

  RewardModel(
      {this.id,
      this.rewardName,
      this.taskId,
      this.taskName,
      this.duration,
      this.condition,
      this.icon,
      this.beginDate,
      this.finishDate,
      this.createDT,
      this.updateDT,
      this.color});

  RewardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rewardName = json['rewardName'];
    taskId = json['taskId'];
    taskName = json['taskName'];
    duration = json['duration'];
    condition = json['condition'];
    icon = json['icon'];
    beginDate = json['beginDate'];
    finishDate = json['finishDate'];
    createDT = json['createDT'];
    updateDT = json['updateDT'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rewardName'] = rewardName;
    data['taskId'] = taskId;
    data['taskName'] = taskName;
    data['duration'] = duration;
    data['condition'] = condition;
    data['icon'] = icon;
    data['beginDate'] = beginDate;
    data['finishDate'] = finishDate;
    data['createDT'] = createDT;
    data['updateDT'] = updateDT;
    data['color'] = color;
    return data;
  }
}
