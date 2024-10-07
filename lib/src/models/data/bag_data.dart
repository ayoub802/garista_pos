import 'address_data.dart';
import 'user_data.dart';
import 'currency_data.dart';

import '../response/payments_response.dart';

class BagData {
  BagData({
    int? index,
    List<BagProductData>? bagProducts,
  }) {
    _index = index;
    _bagProducts = bagProducts;
  }

  BagData.fromJson(dynamic json) {
    _index = json['index'];
    if (json['bag_products'] != null) {
      _bagProducts = [];
      json['bag_products'].forEach((v) {
        _bagProducts?.add(BagProductData.fromJson(v));
      });
    }
  }

  int? _index;
  List<BagProductData>? _bagProducts;

  BagData copyWith({
    int? index,
    List<BagProductData>? bagProducts,
  }) =>
      BagData(
        index: index ?? _index,
        bagProducts: bagProducts ?? _bagProducts,
      );

  int? get index => _index;

  List<BagProductData>? get bagProducts => _bagProducts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['index'] = _index;
    if (_bagProducts != null) {
      map['bag_products'] = _bagProducts?.map((v) => v.toJsonInsert()).toList();
    }
    return map;
  }
}

class BagProductData {
  final int? quantity; // Total quantity of this product
  final List<CartProductData> carts; // List of cart products

  BagProductData({
    this.quantity,
    List<CartProductData>? carts,
  }) : carts = carts ?? [];

  factory BagProductData.fromJson(Map<String, dynamic> data) {
    List<CartProductData> newList = [];
    if (data['products'] != null) {
      newList = List<CartProductData>.from(
          data['products'].map((item) => CartProductData.fromJson(item)));
    }
    return BagProductData(
      quantity: data['quantity'],
      carts: newList,
    );
  }

  // Updated copyWith method
  BagProductData copyWith({
    int? quantity,
    List<CartProductData>? carts,
  }) {
    return BagProductData(
      quantity: quantity ?? this.quantity,
      carts: carts ?? this.carts,
    );
  }

  Map<String, dynamic> toJsonInsert() {
    final map = <String, dynamic>{};
    if (quantity != null) map["quantity"] = quantity;
    if (carts.isNotEmpty)
      map["products"] = carts.map((cart) => cart.toJson()).toList();
    return map;
  }
}
class CartProductData {
  late int productId; // Unique identifier for the product
  late int quantity; // Quantity of this product in the cart
  String? name; // Product name
  String? desc; // Product description
  String? price; // Product price

  CartProductData({
    required this.productId,
    required this.quantity,
    this.name,
    this.desc,
    this.price,
  });

  // Implementing copyWith method
  CartProductData copyWith({
    int? productId,
    int? quantity,
    String? name,
    String? desc,
    String? price,
  }) {
    return CartProductData(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
    );
  }

  factory CartProductData.fromJson(Map<String, dynamic> data) {
    return CartProductData(
      productId: data['productId'],
      quantity: data['quantity'],
      name: data['name'],
      desc: data['desc'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'name': name,
      'desc': desc,
      'price': price,
    };
  }

  @override
  String toString() {
    return 'CartProductData(productId: $productId, quantity: $quantity, name: $name, desc: $desc, price: $price)';
  }
}
