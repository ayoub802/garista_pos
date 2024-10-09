
class TableData {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  TableData({this.id, this.name, this.createdAt, this.updatedAt});

  TableData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Translation {
  int? id;
  String? locale;
  String? title;

  Translation({this.id, this.locale, this.title});

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['locale'] = locale;
    data['title'] = title;
    return data;
  }
}




