class TableModel {
  final String name;
  final int chairCount;

  TableModel({
    required this.name,
    required this.chairCount,
  });

  toJson() => {
        "name": name,
        "chair_count": chairCount,
      };
}
