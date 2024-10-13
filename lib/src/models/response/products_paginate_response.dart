import '../data/product_data.dart';
import 'package:flutter/material.dart';

class ProductsPaginateResponse {
  ProductsPaginateResponse({
    List<ProductData>? data,
  }) {
    _data = data;
  }

  ProductsPaginateResponse.fromJson(dynamic json) {
    if (json is List) {
      _data = [];
      json.forEach((v) {
        _data?.add(ProductData.fromJson(v));
      });
    } else {
      debugPrint("Error: Expected a list for 'data', but got ${json}");
    }
  }

  List<ProductData>? _data;

  ProductsPaginateResponse copyWith({
    List<ProductData>? data,
  }) =>
      ProductsPaginateResponse(
        data: data ?? _data,
      );

  List<ProductData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
