class OrderData {
  OrderData({
    required this.id,
    this.total, // Make total nullable
    this.status, // Make status nullable
    required this.tableId,
    required this.restoId,
    required this.createdAt,
    required this.updatedAt,
    this.table, // Make table nullable
  });

  OrderData.fromJson(dynamic json)
      : id = json['id'],
        total = json['total'], // Leave this as is for now
        status = json['status'], // Leave this as is for now
        tableId = json['table_id'],
        restoId = json['resto_id'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        table = json['table'] != null ? Table.fromJson(json['table']) : null;

  final int id;
  final String? total; // Nullable total
  final String? status; // Nullable status
  final int tableId;
  final int restoId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Table? table; // Nullable table
}

class Table {
  Table({
    required this.id,
    required this.name,
    this.link,
    this.restoId,
    this.seats,
    this.locations,
    this.shape,
    this.staffId,
    this.x,
    this.y,
    required this.createdAt,
    required this.updatedAt,
  });

  Table.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        link = json['link'],
        restoId = json['resto_id'],
        seats = json['seats'],
        locations = json['locations'],
        shape = json['shape'],
        staffId = json['staff_id'],
        x = json['x'],
        y = json['y'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  final int id;
  final String name;
  final String? link;
  final int? restoId;
  final int? seats;
  final String? locations;
  final String? shape;
  final int? staffId;
  final double? x;
  final double? y;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'resto_id': restoId,
      'seats': seats,
      'locations': locations,
      'shape': shape,
      'staff_id': staffId,
      'x': x,
      'y': y,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
