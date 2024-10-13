import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

class CategoriesPaginateResponse {
  CategoriesPaginateResponse({List<CategoryData>? data}) {
    _data = data;
  }

  CategoriesPaginateResponse.fromJson(dynamic json) {
    // No need to check 'data', since the response is now a direct list
    if (json is List) {
      _data = [];
      json.forEach((v) {
        _data?.add(CategoryData.fromJson(v));
      });
    } else {
      debugPrint("Error: Expected a list for 'data', but got ${json}");
    }
  }

  List<CategoryData>? _data;

  CategoriesPaginateResponse copyWith({List<CategoryData>? data}) =>
      CategoriesPaginateResponse(data: data ?? _data);

  List<CategoryData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class CategoryData {
  // Fields
  int? _id;
  String? _name;
  String? _image;
  int? _restoId;
  int? _visibility;
  String? _createdAt;
  String? _updatedAt;
  int? _orderCategorie;
  int? _dishesCount;
  int? _drinksCount;

  // Constructor
  CategoryData({
    int? id,
    String? name,
    String? image,
    int? restoId,
    int? visibility,
    String? createdAt,
    String? updatedAt,
    int? orderCategorie,
    int? dishesCount,
    int? drinksCount,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _restoId = restoId;
    _visibility = visibility;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _orderCategorie = orderCategorie;
    _dishesCount = dishesCount;
    _drinksCount = drinksCount;
  }

  // Helper method to safely parse integers from dynamic JSON data
  int? _parseInt(dynamic value) {
    if (value == null || value == '') return null;
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // JSON deserialization constructor
  CategoryData.fromJson(dynamic json) {
    _id = _parseInt(json['id']);
    _restoId = _parseInt(json['resto_id']);
    _visibility = _parseInt(json['visibility']);
    _orderCategorie = _parseInt(json['orderCategorie']);
    _dishesCount = _parseInt(json['dishes_count']);
    _drinksCount = _parseInt(json['drinks_count']);

    _name = json['name'] != null ? json['name'] : 'Unnamed Category';
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    print("Parsed name: $_name");
  }

  // Getters
  int? get id => _id;
  String? get name => _name;
  String? get image => _image;
  int? get restoId => _restoId;
  int? get visibility => _visibility;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get orderCategorie => _orderCategorie;
  int? get dishesCount => _dishesCount;
  int? get drinksCount => _drinksCount;

  // CopyWith method
  CategoryData copyWith({
    int? id,
    String? name,
    String? image,
    int? restoId,
    int? visibility,
    String? createdAt,
    String? updatedAt,
    int? orderCategorie,
    int? dishesCount,
    int? drinksCount,
  }) =>
      CategoryData(
        id: id ?? _id,
        name: name ?? _name,
        image: image ?? _image,
        restoId: restoId ?? _restoId,
        visibility: visibility ?? _visibility,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        orderCategorie: orderCategorie ?? _orderCategorie,
        dishesCount: dishesCount ?? _dishesCount,
        drinksCount: drinksCount ?? _drinksCount,
      );

  // JSON serialization method
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['resto_id'] = _restoId;
    map['visibility'] = _visibility;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['orderCategorie'] = _orderCategorie;
    map['dishes_count'] = _dishesCount;
    map['drinks_count'] = _drinksCount;
    return map;
  }
}
