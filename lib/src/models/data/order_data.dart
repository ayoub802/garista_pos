class OrderData {
  OrderData({
    int? id,
    String? total, // Nullable total
    String? status, // Nullable status
    int? tableId,
    int? restoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Table? table, // Nullable table
    List<Dish>? dishes,
  }) {
    _id = id;
    _total = total;
    _status = status;
    _tableId = tableId;
    _restoId = restoId;
    _table = table;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _dishes = dishes;
  }

  OrderData.fromJson(dynamic json){
        _id = json['id'];
        _total = json['total']; // Leave this as is for now
        _status = json['status']; // Leave this as is for now
        _tableId = json['table_id'];
        _restoId = json['resto_id'];
        _createdAt = DateTime.parse(json['created_at']);
        _updatedAt = DateTime.parse(json['updated_at']);

        _table = json['table'] != null ? Table.fromJson(json['table']) : null;
       if (json['dishes'] != null) {
        _dishes = (json['dishes'] as List)
            .map((dishJson) {
              return Dish.fromJson(dishJson);
            })
            .toList();
      } else {
        _dishes = [];
      }
  }

  int? _id;
  String? _total;
  String? _status;
  int? _tableId;
  int? _restoId;
  Table? _table;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  List<Dish>? _dishes;

 OrderData copyWith({
    int? id,
    String? total, // Nullable total
    String? status, // Nullable status
    int? tableId,
    int? restoId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Table? table, // Nullable table
    List<Dish>? dishes,
  }) =>
      OrderData(
        id: id ?? _id,
        total: total ?? _total,
        status: status ?? _status,
        tableId: tableId ?? _tableId,
        restoId: restoId ?? _restoId,
        table: table ?? _table,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        dishes: dishes ?? _dishes,
      );

  int? get id => _id;

  String? get total => _total;

  String? get status => _status;

  int? get tableId => _tableId;

  int? get restoId => _restoId;

  DateTime? get createdAt => _createdAt;

  DateTime? get updatedAt => _updatedAt;

  Table? get table => _table;

  List<Dish>? get dishes => _dishes;

 Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['total'] = _total;
    map['status'] = _status;
    map['tableId'] = _tableId;
    map['restoId'] = _restoId;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    if (_table != null) {
      map['table'] = _table?.toJson();
    }
     if (_dishes != null) {
      map['dishes'] = _dishes?.map((dish) => dish.toJson()).toList();
    }
    return map;
  }

}

class Table {
  Table({
    this.id,
    this.name,
    this.link,
    this.restoId,
    this.seats,
    this.locations,
    this.shape,
    this.staffId,
    this.x,
    this.y,
    this.createdAt,
    this.updatedAt,
  });

  Table.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        link = json['link'],
        restoId = json['resto_id'],
        seats = json['seats'],
        locations = json['locations'],
        shape = json['shape'],
        staffId = json['staff_id'],
        x = json['x'],
        y = json['y'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);

  final int? id;
  final String? name;
  final String? link;
  final int? restoId;
  final int? seats;
  final String? locations;
  final String? shape;
  final int? staffId;
  final double? x;
  final double? y;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'link': link,
      'resto_id': restoId,
      'seats': seats,
      'locations': locations,
      'shape': shape,
      'staff_id': staffId,
      'x': x,
      'y': y,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Dish {
  Dish({
    int? id,
    String? name,
    String? desc,
    String? image,
    String? price,
    int? visibility,
    int? categoryId,
    Category? categorie,
    int? restoId,
    String? createdAt,
    String? updatedAt,
    int? quantity,
    String? comment,
    List<Topping>? toppings,
    List<IngredientData>? ingredients,
    List<ExtraVariant>? extraVariants,
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
    if (json['toppings'] != null) {
      _toppings = (json['toppings'] as List)
          .map((topping) => Topping.fromJson(topping))
          .toList();
    } else {
      _toppings = [];
    }
    if (json['extra_variants'] != null) {
      _extraVariants = (json['extra_variants'] as List)
          .map((topping) => ExtraVariant.fromJson(topping))
          .toList();
    } else {
      _extraVariants = [];
    }

      if (json['ingrediants'] != null) {
        _ingredients = (json['ingrediants'] as List)
            .map((ingrediant) => IngredientData.fromJson(ingrediant))
            .toList();
      } else {
        _ingredients = [];
      }

    _categorie =
        json['categorie'] != null ? Category.fromJson(json['categorie']) : null;
  }

  int? _id;
  String? _name;
  String? _desc;
  String? _image;
  String? _price;
  int? _visibility;
  int? _categoryId;
  Category? _categorie;
  int? _restoId;
  String? _createdAt;
  String? _updatedAt;
  int? _quantity;
  String? _comment;
  List<Topping>? _toppings;
  List<IngredientData>? _ingredients;
  List<ExtraVariant>? _extraVariants;


  int? get id => _id;

  String? get name => _name;

  String? get desc => _desc;

  String? get image => _image;

  String? get price => _price;

  int? get visibility => _visibility;

  int? get categoryId => _categoryId;

  int? get restoId => _restoId;
  
  int? get quantity => _quantity;
  
  String? get comment => _comment;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<Topping>? get toppings => _toppings;
  
  List<IngredientData>? get ingrediants => _ingredients;
  
  List<ExtraVariant>? get extraVariants => _extraVariants;


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
    map['toppings'] = _toppings?.map((topping) => topping.toJson()).toList();
    map['ingrediants'] = _ingredients?.map((ingrediant) => ingrediant.toJson()).toList();
    map['extra_variants'] = _extraVariants?.map((extravariant) => extravariant.toJson()).toList();

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

// New Topping class
class Topping {
  Topping({
    int? id,
    String? name,
    List<Option>? options,
  }) {
    _id = id;
    _name = name;
    _options = options;
  }

  Topping.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    if (json['options'] != null) {
      _options = (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList();
    } else {
      _options = [];
    }
  }

  int? _id;
  String? _name;
  List<Option>? _options;

  int? get id => _id;
  String? get name => _name;
  List<Option>? get options => _options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['options'] = _options?.map((option) => option.toJson()).toList();
    return map;
  }
}

// New Option class
class Option {
  Option({
    String? name,
    String? price,
  }) {
    _name = name;
    _price = price;
  }

  Option.fromJson(dynamic json) {
    _name = json['name'];
    _price = json['price'];
  }

  String? _name;
  String? _price;

  String? get name => _name;
  String? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['price'] = _price;
    return map;
  }
}

// New Topping class
class ExtraVariant {
  ExtraVariant({
    int? id,
    String? name,
    List<Option>? options,
  }) {
    _id = id;
    _name = name;
    _options = options;
  }

  ExtraVariant.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    if (json['options'] != null) {
      _options = (json['options'] as List)
          .map((option) => Option.fromJson(option))
          .toList();
    } else {
      _options = [];
    }
  }

  int? _id;
  String? _name;
  List<Option>? _options;

  int? get id => _id;
  String? get name => _name;
  List<Option>? get options => _options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['options'] = _options?.map((option) => option.toJson()).toList();
    return map;
  }
}

class IngredientData {
  String? name;

  IngredientData({this.name}); // Default active to false

  IngredientData.fromJson(dynamic json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    return map;
  }
}
