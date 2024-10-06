import 'dart:convert'; // for jsonDecode
import 'addons_data.dart';
import 'bonus_data.dart';
import 'review_data.dart';
import 'translation.dart';

class ProductData {
  ProductData({
    int? id,
    String? name,
    String? desc,
    String? price,
    String? happyHourPrice,
    bool? isHappyHourActive,
    int? visibility,
    String? visibleFrom,
    String? visibleUntil,
    int? categoryId,
    int? restoId,
    String? createdAt,
    String? updatedAt,
    String? image1,
    String? image2,
    String? image3,
    List<ToppingData>? toppings,
    List<VariantData>? extraVariants,
    RestoData? resto,
    CategoryDataProduct? category,
  }) {
    _id = id;
    _name = name;
    _desc = desc;
    _price = price;
    _happyHourPrice = happyHourPrice;
    _isHappyHourActive = isHappyHourActive;
    _visibility = visibility;
    _visibleFrom = visibleFrom;
    _visibleUntil = visibleUntil;
    _categoryId = categoryId;
    _restoId = restoId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image1 = image1;
    _image2 = image2;
    _image3 = image3;
    _toppings = toppings;
    _extraVariants = extraVariants;
    _resto = resto;
    _category = category;
  }

  ProductData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _desc = json['desc'];
    _price = json['price'];
    _happyHourPrice = json['happy_hour_price'];
    _isHappyHourActive = json['is_happy_hour_active'] == 1;
    _visibility = json['visibility'];
    _visibleFrom = json['visible_from'];
    _visibleUntil = json['visible_until'];
    _categoryId = json['category_id'];
    _restoId = json['resto_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image1 = json['image1'];
    _image2 = json['image2'];
    _image3 = json['image3'];

    if (json['toppings'] != null) {
      _toppings = [];
      json['toppings'].forEach((v) {
        _toppings?.add(ToppingData.fromJson(v));
      });
    }
    if (json['extravariants'] != null) {
      _extraVariants = [];
      json['extravariants'].forEach((v) {
        _extraVariants?.add(VariantData.fromJson(v));
      });
    }
    _resto = json['resto'] != null ? RestoData.fromJson(json['resto']) : null;
    _category = json['categorie'] != null
        ? CategoryDataProduct.fromJson(json['categorie'])
        : null;
  }

  int? _id;
  String? _name;
  String? _desc;
  String? _price;
  String? _happyHourPrice;
  bool? _isHappyHourActive;
  int? _visibility;
  String? _visibleFrom;
  String? _visibleUntil;
  int? _categoryId;
  int? _restoId;
  String? _createdAt;
  String? _updatedAt;
  String? _image1;
  String? _image2;
  String? _image3;
  List<ToppingData>? _toppings;
  List<VariantData>? _extraVariants;
  RestoData? _resto;
  CategoryDataProduct? _category;

  int? get id => _id;
  String? get name => _name;
  String? get desc => _desc;
  String? get price => _price;
  String? get happyHourPrice => _happyHourPrice;
  bool? get isHappyHourActive => _isHappyHourActive;
  int? get visibility => _visibility;
  String? get visibleFrom => _visibleFrom;
  String? get visibleUntil => _visibleUntil;
  int? get categoryId => _categoryId;
  int? get restoId => _restoId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image1 => _image1;
  String? get image2 => _image2;
  String? get image3 => _image3;
  List<ToppingData>? get toppings => _toppings;
  List<VariantData>? get extraVariants => _extraVariants;
  RestoData? get resto => _resto;
  CategoryDataProduct? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;
    map['price'] = _price;
    map['happy_hour_price'] = _happyHourPrice;
    map['is_happy_hour_active'] = _isHappyHourActive;
    map['visibility'] = _visibility;
    map['visible_from'] = _visibleFrom;
    map['visible_until'] = _visibleUntil;
    map['category_id'] = _categoryId;
    map['resto_id'] = _restoId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['image1'] = _image1;
    map['image2'] = _image2;
    map['image3'] = _image3;

    if (_toppings != null) {
      map['toppings'] = _toppings?.map((v) => v.toJson()).toList();
    }
    if (_extraVariants != null) {
      map['extravariants'] = _extraVariants?.map((v) => v.toJson()).toList();
    }
    if (_resto != null) {
      map['resto'] = _resto?.toJson();
    }
    if (_category != null) {
      map['categorie'] = _category?.toJson();
    }
    return map;
  }
}

class ToppingData {
  ToppingData({
    int? id,
    String? name,
    List<ToppingOptionData>? options,
    bool? required,
    bool? multipleSelection,
  }) {
    _id = id;
    _name = name;
    _options = options;
    _required = required;
    _multipleSelection = multipleSelection;
  }

  ToppingData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    if (json['options'] != null && json['options'] is String) {
      var optionsJson = jsonDecode(json['options']);
      if (optionsJson is List) {
        _options = optionsJson
            .map((option) => ToppingOptionData.fromJson(option))
            .toList();
      }
    }
    _required = json['required'];
    _multipleSelection = json['multiple_selection'];
  }

  int? _id;
  String? _name;
  List<ToppingOptionData>? _options;
  bool? _required;
  bool? _multipleSelection;

  int? get id => _id;
  String? get name => _name;
  List<ToppingOptionData>? get options => _options;
  bool? get required => _required;
  bool? get multipleSelection => _multipleSelection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_options != null) {
      map['options'] = jsonEncode(_options?.map((v) => v.toJson()).toList());
    }
    map['required'] = _required;
    map['multiple_selection'] = _multipleSelection;
    return map;
  }
}

class VariantData {
  VariantData({
    int? id,
    String? name,
    List<VariantOptionData>? options,
    bool? required,
    bool? multipleSelection,
  }) {
    _id = id;
    _name = name;
    _options = options;
    _required = required;
    _multipleSelection = multipleSelection;
  }

  VariantData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    if (json['options'] != null && json['options'] is String) {
      var optionsJson = jsonDecode(json['options']);
      if (optionsJson is List) {
        _options = optionsJson
            .map((option) => VariantOptionData.fromJson(option))
            .toList();
      }
    }

    _required = json['required'];
    _multipleSelection = json['multiple_selection'];
  }

  int? _id;
  String? _name;
  List<VariantOptionData>? _options;
  bool? _required;
  bool? _multipleSelection;

  int? get id => _id;
  String? get name => _name;
  List<VariantOptionData>? get options => _options;
  bool? get required => _required;
  bool? get multipleSelection => _multipleSelection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_options != null) {
      map['options'] = jsonEncode(_options?.map((v) => v.toJson()).toList());
    }

    map['required'] = _required;
    map['multiple_selection'] = _multipleSelection;
    return map;
  }
}

class RestoData {
  RestoData({
    int? id,
    String? name,
    String? slug,
  }) {
    _id = id;
    _name = name;
    _slug = slug;
  }

  RestoData.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
  }

  int? _id;
  String? _name;
  String? _slug;

  int? get id => _id;
  String? get name => _name;
  String? get slug => _slug;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['slug'] = _slug;
    return map;
  }
}

class CategoryDataProduct {
  CategoryDataProduct({
    int? id,
    String? name,
  }) {
    _id = id;
    _name = name;
  }

  CategoryDataProduct.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  int? _id;
  String? _name;

  int? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

class ToppingOptionData {
  ToppingOptionData({
    String? name,
    String? price,
    bool isSelected = false, // Default value to false
  }) {
    _name = name;
    _price = price;
    _isSelected = isSelected;
  }

  ToppingOptionData.fromJson(dynamic json) {
    _name = json['name'];
    _price = json['price'];
    _isSelected = json['isSelected'] ?? false;
  }

  String? _name;
  String? _price;
  late bool _isSelected;

  String? get name => _name;
  String? get price => _price;
  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['price'] = _price;
    map['isSelected'] = _isSelected;
    return map;
  }
}

class VariantOptionData {
  VariantOptionData({
    String? name,
    String? price,
  }) {
    _name = name;
    _price = price;
  }

  VariantOptionData.fromJson(dynamic json) {
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

class Stocks {
  Stocks({
    int? id,
    int? countableId,
    num? price,
    int? quantity,
    num? discount,
    num? tax,
    num? totalPrice,
    String? img,
    Translation? translation,
    BonusModel? bonus,
    List<Extras>? extras,
    List<Addons>? addons,
    ProductData? product,
  }) {
    _bonus = bonus;
    _id = id;
    _countableId = countableId;
    _price = price;
    _quantity = quantity;
    _discount = discount;
    _img = img;
    _translation = translation;
    _tax = tax;
    _totalPrice = totalPrice;
    _extras = extras;
    _addons = addons;
    _product = product;
  }

  Stocks.fromJson(dynamic json) {
    _bonus = json?["bonus"] != null ? BonusModel.fromJson(json["bonus"]) : null;
    _id = json?['id'];
    _countableId = json?['countable_id'];
    _price = json?['price'];
    _img = json?["product"]?["img"];
    if (json["product"]?["translation"] != null) {
      _translation = Translation.fromJson(json["product"]["translation"]);
    }
    _quantity = json?['quantity'];
    _discount = json?['discount'];
    _tax = json?['tax'];
    _totalPrice = json?['total_price'];
    if (json?['extras'] != null) {
      _extras = [];
      if (json?['extras'].runtimeType != bool) {
        json?['extras'].forEach((v) {
          _extras?.add(Extras.fromJson(v));
        });
      }
    }
    if (json?['stock_extras'] != null) {
      _extras = [];
      if (json?['stock_extras'].runtimeType != bool) {
        json?['stock_extras'].forEach((v) {
          _extras?.add(Extras.fromJson(v));
        });
      }
    }
    if (json?['addons'] != null) {
      _addons = [];
      json?['addons'].forEach((v) {
        if (v["product"] != null || v["stock"] != null) {
          _addons?.add(Addons.fromJson(v));
        }
      });
    }
    _product = (json?['product'] != null
        ? ProductData.fromJson(json['product'])
        : (json?['countable'] != null
            ? ProductData.fromJson(json["countable"])
            : null));
  }

  int? _id;
  int? _countableId;
  num? _price;
  int? _quantity;
  num? _discount;
  String? _img;
  Translation? _translation;
  num? _tax;
  BonusModel? _bonus;
  num? _totalPrice;
  List<Extras>? _extras;
  ProductData? _product;
  List<Addons>? _addons;

  Stocks copyWith({
    int? id,
    int? countableId,
    num? price,
    int? quantity,
    String? img,
    Translation? translation,
    num? discount,
    num? tax,
    BonusModel? bonus,
    num? totalPrice,
    List<Extras>? extras,
    List<Addons>? addons,
    ProductData? product,
  }) =>
      Stocks(
          bonus: bonus ?? _bonus,
          id: id ?? _id,
          countableId: countableId ?? _countableId,
          price: price ?? _price,
          img: img ?? _img,
          translation: translation ?? _translation,
          quantity: quantity ?? _quantity,
          discount: discount ?? _discount,
          tax: tax ?? _tax,
          totalPrice: totalPrice ?? _totalPrice,
          extras: extras ?? _extras,
          product: product ?? _product,
          addons: addons ?? _addons);

  int? get id => _id;

  int? get countableId => _countableId;

  num? get price => _price;

  String? get img => _img;

  Translation? get translation => _translation;

  int? get quantity => _quantity;

  num? get discount => _discount;

  num? get tax => _tax;

  num? get totalPrice => _totalPrice;

  BonusModel? get bonus => _bonus;

  List<Addons>? get addons => _addons;

  List<Extras>? get extras => _extras;

  ProductData? get product => _product;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['countable_id'] = _countableId;
    map['price'] = _price;
    map['quantity'] = _quantity;
    map['discount'] = _discount;
    map['tax'] = _tax;
    map['total_price'] = _totalPrice;
    if (_extras != null) {
      map['extras'] = _extras?.map((v) => v.toJson()).toList();
    }
    if (_product != null) {
      map['product'] = _product?.toJson();
    }
    return map;
  }
}

class Extras {
  Extras({
    int? id,
    int? extraGroupId,
    String? value,
    Group? group,
  }) {
    _id = id;
    _extraGroupId = extraGroupId;
    _value = value;
    _active = active;
    _group = group;
  }

  Extras.fromJson(dynamic json) {
    _id = json['id'];
    _extraGroupId = json['extra_group_id'];
    _value = json['value'];
    _group = json['group'] != null ? Group.fromJson(json['group']) : null;
  }

  int? _id;
  int? _extraGroupId;
  String? _value;
  bool? _active;
  Group? _group;

  Extras copyWith({
    int? id,
    int? extraGroupId,
    String? value,
    bool? active,
    Group? group,
  }) =>
      Extras(
        id: id ?? _id,
        extraGroupId: extraGroupId ?? _extraGroupId,
        value: value ?? _value,
        group: group ?? _group,
      );

  int? get id => _id;

  int? get extraGroupId => _extraGroupId;

  String? get value => _value;

  bool? get active => _active;

  Group? get group => _group;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['extra_group_id'] = _extraGroupId;
    map['value'] = _value;
    map['active'] = _active;
    if (_group != null) {
      map['group'] = _group?.toJson();
    }
    return map;
  }
}

class Group {
  Group({
    int? id,
    String? type,
    bool? active,
    Translation? translation,
  }) {
    _id = id;
    _type = type;
    _active = active;
    _translation = translation;
  }

  Group.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
  }

  int? _id;
  String? _type;
  bool? _active;
  Translation? _translation;

  Group copyWith({
    int? id,
    String? type,
    bool? active,
    Translation? translation,
  }) =>
      Group(
        id: id ?? _id,
        type: type ?? _type,
        active: active ?? _active,
        translation: translation ?? _translation,
      );

  int? get id => _id;

  String? get type => _type;

  bool? get active => _active;

  Translation? get translation => _translation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['active'] = _active;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    return map;
  }
}

class Properties {
  Properties({
    String? locale,
    String? key,
    String? value,
  }) {
    _locale = locale;
    _key = key;
    _value = value;
  }

  Properties.fromJson(dynamic json) {
    _locale = json['locale'];
    _key = json['key'];
    _value = json['value'];
  }

  String? _locale;
  String? _key;
  String? _value;

  Properties copyWith({
    String? locale,
    String? key,
    String? value,
  }) =>
      Properties(
        locale: locale ?? _locale,
        key: key ?? _key,
        value: value ?? _value,
      );

  String? get locale => _locale;

  String? get key => _key;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locale'] = _locale;
    map['key'] = _key;
    map['value'] = _value;
    return map;
  }
}
