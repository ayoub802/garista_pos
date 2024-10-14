import 'order_data.dart';

class NotificationResponse {
  List<NotificationModel>? data;
  int? currentPage;
  int? from;
  int? lastPage;
  String? lastPageUrl;

  NotificationResponse({
    this.data,
    this.currentPage,
    this.from,
    this.lastPage,
    this.lastPageUrl,
  });

  NotificationResponse copyWith({
    List<NotificationModel>? data,
    int? currentPage,
    int? from,
    int? lastPage,
    String? lastPageUrl,
  }) =>
      NotificationResponse(
        data: data ?? this.data,
        currentPage: currentPage ?? this.currentPage,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
      );

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        currentPage: json['current_page'],
        data: json["data"] == null
            ? []
            : List<NotificationModel>.from(
                json["data"]!.map((x) => NotificationModel.fromJson(x))),
        from: json['from'],
        lastPage: json['last_page'],
        lastPageUrl: json['last_page_url'],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotificationModel {
  int? id;
  String? title;
  int? restoId;
  String? status;
  int? tableId;
  int? viewed;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? readAt;

  NotificationModel({
    this.id,
    this.title,
    this.restoId,
    this.status,
    this.tableId,
    this.viewed,
    this.createdAt,
    this.updatedAt,
    this.readAt,
  });

  NotificationModel copyWith({
    int? id,
    String? title,
    int? restoId,
    String? status,
    int? tableId,
    int? viewed,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? readAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        title: title ?? this.title,
        restoId: restoId ?? this.restoId,
        status: status ?? this.status,
        tableId: tableId ?? this.tableId,
        viewed: viewed ?? this.viewed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        readAt: readAt ?? this.readAt,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        restoId: json["resto_id"],
        status: json["status"],
        tableId: json["table_id"],
        viewed: json["viewed"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"])?.toLocal()
            : null,
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"])?.toLocal()
            : null,
        readAt: json["read_at"] != null
            ? DateTime.tryParse(json["read_at"])?.toLocal()
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "resto_id": restoId,
        "status": status,
        "table_id": tableId,
        "viewed": viewed,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "read_at": readAt?.toIso8601String(),
      };
}

class Client {
  int? id;
  String? firstname;
  String? lastname;
  bool? emptyP;
  int? active;
  String? role;
  String? img;

  Client({
    this.id,
    this.firstname,
    this.lastname,
    this.emptyP,
    this.active,
    this.role,
    this.img,
  });

  Client copyWith({
    int? id,
    String? firstname,
    String? lastname,
    bool? emptyP,
    int? active,
    String? role,
    String? img,
  }) =>
      Client(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        emptyP: emptyP ?? this.emptyP,
        active: active ?? this.active,
        role: role ?? this.role,
        img: img ?? this.img,
      );

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        emptyP: json["empty_p"],
        active: json["active"],
        role: json["role"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "empty_p": emptyP,
        "active": active,
        "role": role,
        "img": img,
      };
}

class Data {
  int? id;
  String? type;
  String? status;

  Data({
    this.id,
    this.type,
    this.status,
  });

  Data copyWith({
    int? id,
    String? type,
    String? status,
  }) =>
      Data(
        id: id ?? this.id,
        type: type ?? this.type,
        status: status ?? this.status,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "status": status,
      };
}
