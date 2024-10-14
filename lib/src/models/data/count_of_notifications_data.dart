class CountNotificationModel {
  int? notification;

  CountNotificationModel({
    this.notification,
  });

  CountNotificationModel copyWith({
    int? notification,
    int? transaction,
  }) =>
      CountNotificationModel(
        notification: notification ?? this.notification,
      );

  factory CountNotificationModel.fromJson(Map<String, dynamic> json) =>
      CountNotificationModel(
        notification: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "notification": notification,
      };
}
