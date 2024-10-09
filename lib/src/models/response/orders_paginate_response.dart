import 'package:garista_pos/src/models/data/order_data.dart';

class OrdersPaginateResponse {
    OrdersPaginateResponse({List<OrderData>? orders}) {
        _orders = orders;
    }

    OrdersPaginateResponse.fromJson(dynamic json) {
        if (json is List) {
            _orders = json.map((v) => OrderData.fromJson(v)).toList();
        }
    }

    List<OrderData>? _orders;

    List<OrderData>? get orders => _orders;

    Map<String, dynamic> toJson() {
        final map = <String, dynamic>{};
        if (_orders != null) {
            map['orders'] = _orders?.map((v) => v.toJson()).toList();
        }
        return map;
    }
}

class OrderResponseData {
  OrderResponseData({
    List<OrderData>? orders,
  }) {
    _orders = orders;
  }

  OrderResponseData.fromJson(dynamic json) {
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders?.add(OrderData.fromJson(v));
      });
    }
  }

  List<OrderData>? _orders;

  OrderResponseData copyWith({
    List<OrderData>? orders,
  }) =>
      OrderResponseData(
        orders: orders ?? _orders,
      );


  List<OrderData>? get orders => _orders;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_orders != null) {
      map['orders'] = _orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

