class OrderDetail {
  OrderDetail({
    int? id,
    String? total,
    String? status,
    int? tableId,
    int? restoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Dish>? dishes, // Add a list of Dish objects
  }) {
    _id = id;
    _total = total;
    _status = status;
    _tableId = tableId;
    _restoId = restoId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _dishes = dishes; // Initialize the dishes list
  }

  OrderDetail.fromJson(dynamic json) {
    _id = json['id'];
    _total = json['total'];
    _status = json['status'];
    _tableId = json['table_id'];
    _restoId = json['resto_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    // Deserialize the list of Dish objects
    if (json['dishes'] != null) {
      _dishes = [];
      json['dishes'].forEach((v) {
        _dishes?.add(Dish.fromJson(v));
      });
    }
  }

  int? _id;
  String? _total;
  String? _status;
  int? _tableId;
  int? _restoId;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  List<Dish>? _dishes; // List of dishes in the order

  int? get id => _id;
  String? get total => _total;
  String? get status => _status;
  int? get tableId => _tableId;
  int? get restoId => _restoId;
  DateTime? get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;
  List<Dish>? get dishes => _dishes; // Getter for dishes

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['total'] = _total;
    map['status'] = _status;
    map['table_id'] = _tableId;
    map['resto_id'] = _restoId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;

    // Serialize the list of Dish objects
    if (_dishes != null) {
      map['dishes'] = _dishes?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class Dish {
  Dish({
    int? id,
    String? name,
    String? desc,
    String? image,
    num? price,
    int? visibility,
    int? categoryId,
    Category? categorie,
    int? restoId,
    String? createdAt,
    String? updatedAt,
    int? quantity,
    String? comment,
    List<dynamic>? toppings,
    List<dynamic>? ingredients,
    List<dynamic>? extraVariants,
  }) {
    _id = id;
    _name = name;
    _desc = desc;
    _image = image;
    _price = price;
    _visibility = visibility;
    _categoryId = categoryId;
    _categorie = categorie;
    _restoId = restoId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _quantity = quantity;
    _comment = comment;
    _toppings = toppings;
    _ingredients = ingredients;
    _extraVariants = extraVariants;
  }

  Dish.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _desc = json['desc'];
    _image = json['image'];
    _price = json['price'];
    _visibility = json['visibility'];
    _categoryId = json['category_id'];
    _restoId = json['resto_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _quantity = json['quantity'];
    _comment = json['comment'];
    _toppings = json['toppings'] ?? [];
    _ingredients = json['ingrediants'] ?? [];
    _extraVariants = json['extra_variants'] ?? [];

    _categorie =
        json['categorie'] != null ? Category.fromJson(json['categorie']) : null;
  }

  int? _id;
  String? _name;
  String? _desc;
  String? _image;
  num? _price;
  int? _visibility;
  int? _categoryId;
  Category? _categorie;
  int? _restoId;
  String? _createdAt;
  String? _updatedAt;
  int? _quantity;
  String? _comment;
  List<dynamic>? _toppings;
  List<dynamic>? _ingredients;
  List<dynamic>? _extraVariants;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;
    map['image'] = _image;
    map['price'] = _price;
    map['visibility'] = _visibility;
    map['category_id'] = _categoryId;
    map['resto_id'] = _restoId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['quantity'] = _quantity;
    map['comment'] = _comment;
    map['toppings'] = _toppings;
    map['ingrediants'] = _ingredients;
    map['extra_variants'] = _extraVariants;

    if (_categorie != null) {
      map['categorie'] = _categorie?.toJson();
    }

    return map;
  }
}

class Category {
  Category({
    int? id,
    String? name,
    String? image,
    int? restoId,
    int? visibility,
    String? createdAt,
    String? updatedAt,
    int? orderCategorie,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _restoId = restoId;
    _visibility = visibility;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _orderCategorie = orderCategorie;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _restoId = json['resto_id'];
    _visibility = json['visibility'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _orderCategorie = json['orderCategorie'];
  }

  int? _id;
  String? _name;
  String? _image;
  int? _restoId;
  int? _visibility;
  String? _createdAt;
  String? _updatedAt;
  int? _orderCategorie;

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

    return map;
  }
}
