class TableModel {
  final String name;
  final dynamic id;
  final int chairCount;

  TableModel({
    required this.name,
    this.id,
    required this.chairCount,
  });

  toJson() => {
        "name": name,
        "id": id,
        "chair_count": chairCount,
      };
}
