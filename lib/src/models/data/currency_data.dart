class CurrencyData {
  CurrencyData({
    int? id,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _type = type;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  CurrencyData.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  String? _type;
  String? _createdAt;
  String? _updatedAt;

  CurrencyData copyWith({
    int? id,
    String? type,
    String? createdAt,
    String? updatedAt,
  }) =>
      CurrencyData(
        id: id ?? _id,
        type: type ?? _type,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  int? get id => _id;
  String? get type => _type;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
