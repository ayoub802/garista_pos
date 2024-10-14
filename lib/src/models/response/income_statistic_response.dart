class IncomeStatisticResponse {
  StatisticModel? incomeStatisticResponseNew;
  StatisticModel? accepted;
  StatisticModel? ready;
  StatisticModel? preparing;
  StatisticModel? completed;
  StatisticModel? rejected;
  Group? group;

  IncomeStatisticResponse({
    this.incomeStatisticResponseNew,
    this.accepted,
    this.ready,
    this.preparing,
    this.completed,
    this.rejected,
    this.group,
  });

  IncomeStatisticResponse copyWith({
    StatisticModel? incomeStatisticResponseNew,
    StatisticModel? accepted,
    StatisticModel? ready,
    StatisticModel? preparing,
    StatisticModel? completed,
    StatisticModel? rejected,
    Group? group,
  }) =>
      IncomeStatisticResponse(
        incomeStatisticResponseNew:
            incomeStatisticResponseNew ?? this.incomeStatisticResponseNew,
        accepted: accepted ?? this.accepted,
        ready: ready ?? this.ready,
        preparing: preparing ?? this.preparing,
        completed: completed ?? this.completed,
        rejected: rejected ?? this.rejected,
        group: group ?? this.group,
      );

  factory IncomeStatisticResponse.fromJson(Map<String, dynamic> json) =>
      IncomeStatisticResponse(
        incomeStatisticResponseNew:
            json["new"] == null ? null : StatisticModel.fromJson(json["new"]),
        accepted: json["accepted"] == null
            ? null
            : StatisticModel.fromJson(json["accepted"]),
        ready: json["ready"] == null
            ? null
            : StatisticModel.fromJson(json["ready"]),
        preparing: json["preparing"] == null
            ? null
            : StatisticModel.fromJson(json["preparing"]),
        completed: json["completed"] == null
            ? null
            : StatisticModel.fromJson(json["completed"]),
        rejected: json["rejected"] == null
            ? null
            : StatisticModel.fromJson(json["rejected"]),
        group: json["group"] == null ? null : Group.fromJson(json["group"]),
      );

  Map<String, dynamic> toJson() => {
        "new": incomeStatisticResponseNew?.toJson(),
        "accepted": accepted?.toJson(),
        "ready": ready?.toJson(),
        "preparing": preparing?.toJson(),
        "completed": completed?.toJson(),
        "rejected": rejected?.toJson(),
        "group": group?.toJson(),
      };
}

class StatisticModel {
  num? sum;
  num? percent;

  StatisticModel({
    this.sum,
    this.percent,
  });

  StatisticModel copyWith({
    num? sum,
    num? percent,
  }) =>
      StatisticModel(
        sum: sum ?? this.sum,
        percent: percent ?? this.percent,
      );

  factory StatisticModel.fromJson(Map<String, dynamic> json) => StatisticModel(
        sum: json["sum"],
        percent: json["percent"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "sum": sum,
        "percent": percent,
      };
}

class Group {
  StatisticModel? active;
  StatisticModel? completed;
  StatisticModel? ended;

  Group({
    this.active,
    this.completed,
    this.ended,
  });

  Group copyWith({
    StatisticModel? active,
    StatisticModel? completed,
    StatisticModel? ended,
  }) =>
      Group(
        active: active ?? this.active,
        completed: completed ?? this.completed,
        ended: ended ?? this.ended,
      );

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        active: json["active"] == null
            ? null
            : StatisticModel.fromJson(json["active"]),
        completed: json["completed"] == null
            ? null
            : StatisticModel.fromJson(json["completed"]),
        ended: json["ended"] == null
            ? null
            : StatisticModel.fromJson(json["ended"]),
      );

  Map<String, dynamic> toJson() => {
        "active": active?.toJson(),
        "completed": completed?.toJson(),
        "ended": ended?.toJson(),
      };
}
