import 'address_data.dart';
import 'user_data.dart';
import 'currency_data.dart';
import 'product_data.dart';

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
  double? price; // Product price
  String? type; // Product price
  List<ToppingData>? selectedToppings;
  List<VariantData>? selectedVariants;
  List<IngredientData>? selectedIngrediants;
  CartProductData(
      {required this.productId,
      required this.quantity,
      this.name,
      this.desc,
      this.price,
      required this.type,
      this.selectedToppings,
      this.selectedVariants,
      this.selectedIngrediants});

  // Implementing copyWith method
  CartProductData copyWith({
    int? productId,
    int? quantity,
    String? name,
    String? desc,
    String? type,
    double? price,
    List<ToppingData>? selectedToppings,
    List<VariantData>? selectedVariants,
    List<IngredientData>? selectedIngrediants,
  }) {
    return CartProductData(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      type: type ?? this.type,
      selectedToppings: selectedToppings ?? this.selectedToppings,
      selectedVariants: selectedVariants ?? this.selectedVariants,
      selectedIngrediants: selectedIngrediants ?? this.selectedIngrediants,
    );
  }

  factory CartProductData.fromJson(Map<String, dynamic> data) {
    List<ToppingData> toppings = [];
    if (data['selectedToppings'] != null) {
      toppings = (data['selectedToppings'] as List)
          .map((topping) => ToppingData.fromJson(topping))
          .toList();
    }

    List<VariantData> variants = [];
    if (data['selectedVariants'] != null) {
      variants = (data['selectedVariants'] as List)
          .map((variant) => VariantData.fromJson(variant))
          .toList();
    }

    List<IngredientData> ingredients = [];
    if (data['selectedIngrediants'] != null) {
      ingredients = (data['selectedIngrediants'] as List)
          .map((ingredient) => IngredientData.fromJson(ingredient))
          .toList();
    }

    return CartProductData(
      productId: data['productId'],
      quantity: data['quantity'],
      name: data['name'],
      desc: data['desc'],
      price: data['price'],
      type: data['type'],
      selectedToppings: data['selectedToppings'] != null ? toppings : [],
      selectedVariants: data['selectedVariants'] != null ? variants : [],
      selectedIngrediants:
          data['selectedIngrediants'] != null ? ingredients : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'name': name,
      'desc': desc,
      'price': price,
      'type': type,
      'selectedToppings':
          selectedToppings?.map((topping) => topping.toJson()).toList(),
      'selectedVariants':
          selectedVariants?.map((variant) => variant.toJson()).toList(),
      'selectedIngrediants': selectedIngrediants
          ?.map((ingrediant) => ingrediant.toJson())
          .toList(),
    };
  }

  @override
  String toString() {
    // Customize toString to include selected toppings
    String toppingsString =
        selectedToppings != null && selectedToppings!.isNotEmpty
            ? selectedToppings!.map((topping) => topping.toString()).join(', ')
            : 'No toppings';
    String variantsString = selectedVariants != null &&
            selectedVariants!.isNotEmpty
        ? selectedVariants!.map((variants) => variants.toString()).join(', ')
        : 'No Variants';
    String IngredientString =
        selectedIngrediants != null && selectedIngrediants!.isNotEmpty
            ? selectedIngrediants!
                .map((ingredient) => ingredient.toString())
                .join(', ')
            : 'No Ingredient';
    return 'CartProductData(productId: $productId, quantity: $quantity, name: $name, desc: $desc, price: $price, type: $type, selectedToppings: [$toppingsString], selectedVariants: [$variantsString], selectedIngrediants: [$IngredientString])';
  }
}
