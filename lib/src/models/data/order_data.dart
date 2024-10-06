import 'package:garista_pos/src/models/data/addons_data.dart';
import 'package:garista_pos/src/models/models.dart';
import 'package:garista_pos/src/models/response/kitchen_orders_response.dart';
import 'location_data.dart';

class OrderData {
  OrderData({
    int? id,
    int? userId,
    num? orderDetailsCount,
    num? totalPrice,
    num? rate,
    num? tax,
    num? totalDiscount,
    num? commissionFee,
    String? status,
    LocationData? location,
    String? deliveryType,
    String? phone,
    num? deliveryFee,
    UserData? deliveryman,
    DateTime? deliveryDate,
    String? deliveryTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopData? shop,
    CurrencyData? currency,
    UserData? user,
    List<OrderDetail>? details,
    Transaction? transaction,
    OrderAddress? orderAddress,
    dynamic review,
    String? note,
    bool? seen,
  }) {
    _id = id;
    _userId = userId;
    _orderDetailsCount = orderDetailsCount;
    _totalPrice = totalPrice;
    _rate = rate;
    _tax = tax;
    _totalDiscount = totalDiscount;
    _commissionFee = commissionFee;
    _status = status;
    _location = location;
    _deliveryType = deliveryType;
    _phone = phone;
    _deliveryFee = deliveryFee;
    _deliveryman = deliveryman;
    _deliveryDate = deliveryDate;
    _deliveryTime = deliveryTime;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _shop = shop;
    _currency = currency;
    _user = user;
    _details = details;
    _transaction = transaction;
    _orderAddress = orderAddress;
    _review = review;
    _note = note;
    _seen = seen;
  }

  OrderData.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _totalPrice = json['total_price'];
    _rate = json['rate'];
    _tax = json['tax'];
    _totalDiscount = json["total_discount"];
    _commissionFee = json['commission_fee'];
    _orderDetailsCount = json["order_details_count"];
    _status = json['status'];
    _location = json['location'] != null
        ? LocationData.fromJson(json['location'])
        : null;
    _phone = json['phone'];
    _deliveryType = json['delivery_type'];
    _deliveryFee = json['delivery_fee'];
    _deliveryman = json['deliveryman'] != null
        ? UserData.fromJson(json['deliveryman'])
        : null;
    _deliveryDate = DateTime.tryParse(json['delivery_date'].toString());
    _deliveryTime = json['delivery_time'];
    _createdAt = DateTime.tryParse(json['created_at'].toString());
    _updatedAt = DateTime.tryParse(json['updated_at'].toString());
    _shop = json['shop'] != null ? ShopData.fromJson(json['shop']) : null;
    _currency = json['currency'] != null
        ? CurrencyData.fromJson(json['currency'])
        : null;
    _user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details?.add(OrderDetail.fromJson(v));
      });
    }
    _transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
    _orderAddress =
        json['address'] != null ? OrderAddress.fromJson(json['address']) : null;
    _review = json['review'];
    _note = json['note'];
    _seen = false;
  }

  int? _id;
  int? _userId;
  num? _totalPrice;
  num? _orderDetailsCount;
  num? _rate;
  num? _tax;
  num? _totalDiscount;
  num? _commissionFee;
  String? _status;
  LocationData? _location;
  String? _deliveryType;
  String? _phone;
  num? _deliveryFee;
  UserData? _deliveryman;
  DateTime? _deliveryDate;
  String? _deliveryTime;
  DateTime? _createdAt;
  DateTime? _updatedAt;
  ShopData? _shop;
  CurrencyData? _currency;
  UserData? _user;
  List<OrderDetail>? _details;
  Transaction? _transaction;
  OrderAddress? _orderAddress;
  dynamic _review;
  String? _note;
  bool? _seen;

  OrderData copyWith({
    int? id,
    int? userId,
    num? totalPrice,
    num? orderDetailsCount,
    num? rate,
    num? tax,
    num? totalDiscount,
    num? commissionFee,
    String? status,
    LocationData? location,
    String? deliveryType,
    String? phone,
    num? deliveryFee,
    dynamic deliveryman,
    DateTime? deliveryDate,
    String? deliveryTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    ShopData? shop,
    CurrencyData? currency,
    UserData? user,
    List<OrderDetail>? details,
    Transaction? transaction,
    OrderAddress? orderAddress,
    dynamic review,
    String? note,
    bool? seen,
  }) =>
      OrderData(
        id: id ?? _id,
        userId: userId ?? _userId,
        totalPrice: totalPrice ?? _totalPrice,
        orderDetailsCount: orderDetailsCount ?? _orderDetailsCount,
        rate: rate ?? _rate,
        tax: tax ?? _tax,
        totalDiscount: totalDiscount ?? _totalDiscount,
        commissionFee: commissionFee ?? _commissionFee,
        status: status ?? _status,
        location: location ?? _location,
        deliveryType: deliveryType ?? _deliveryType,
        phone: _phone ?? _phone,
        deliveryFee: deliveryFee ?? _deliveryFee,
        deliveryman: deliveryman ?? _deliveryman,
        deliveryDate: deliveryDate ?? _deliveryDate,
        deliveryTime: deliveryTime ?? _deliveryTime,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        shop: shop ?? _shop,
        currency: currency ?? _currency,
        user: user ?? _user,
        details: details ?? _details,
        transaction: transaction ?? _transaction,
        review: review ?? _review,
        note: note ?? _note,
        seen: seen ?? _seen,
      );

  int? get id => _id;

  int? get userId => _userId;

  num? get totalPrice => _totalPrice;

  num? get orderDetailsCount => _orderDetailsCount;

  num? get rate => _rate;

  num? get tax => _tax;

  num? get totalDiscount => _totalDiscount;

  num? get commissionFee => _commissionFee;

  String? get status => _status;

  LocationData? get location => _location;

  String? get deliveryType => _deliveryType;

  String? get phone => _phone;

  num? get deliveryFee => _deliveryFee;

  UserData? get deliveryman => _deliveryman;

  DateTime? get deliveryDate => _deliveryDate;

  String? get deliveryTime => _deliveryTime;

  DateTime? get createdAt => _createdAt;

  DateTime? get updatedAt => _updatedAt;

  ShopData? get shop => _shop;

  CurrencyData? get currency => _currency;

  UserData? get user => _user;

  List<OrderDetail>? get details => _details;

  Transaction? get transaction => _transaction;

  OrderAddress? get orderAddress => _orderAddress;

  dynamic get review => _review;

  String? get note => _note;

  bool? get seen => _seen;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['total_price'] = _totalPrice;
    map['rate'] = _rate;
    map['tax'] = _tax;
    map['commission_fee'] = _commissionFee;
    map['status'] = _status;
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    map['phone'] = _phone;
    map['delivery_type'] = _deliveryType;
    map['delivery_fee'] = _deliveryFee;
    map['deliveryman'] = _deliveryman;
    map['delivery_date'] = _deliveryDate;
    map['delivery_time'] = _deliveryTime;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_shop != null) {
      map['shop'] = _shop?.toJson();
    }
    if (_currency != null) {
      map['currency'] = _currency?.toJson();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_details != null) {
      map['details'] = _details?.map((v) => v.toJson()).toList();
    }
    if (_transaction != null) {
      map['transaction'] = _transaction?.toJson();
    }
    map['review'] = _review;
    map['seen'] = _seen;
    return map;
  }
}

class OrderDetail {
  OrderDetail({
    int? id,
    int? orderId,
    int? stockId,
    num? originPrice,
    num? totalPrice,
    num? tax,
    num? discount,
    int? quantity,
    bool? bonus,
    String? createdAt,
    String? status,
    String? updatedAt,
    Stocks? stock,
    KitchenModel? kitchen,
    List<Addons>? addons,
    bool? isChecked,
  }) {
    _id = id;
    _orderId = orderId;
    _stockId = stockId;
    _status = status;
    _kitchen = kitchen;
    _originPrice = originPrice;
    _totalPrice = totalPrice;
    _tax = tax;
    _discount = discount;
    _quantity = quantity;
    _bonus = bonus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _stock = stock;
    _addons = addons;
    _isChecked = isChecked;
  }

  OrderDetail.fromJson(dynamic json) {
    _id = json['id'];
    _status = json['status'];
    _orderId = json['order_id'];
    _stockId = json['stock_id'];
    _originPrice = json['origin_price'];
    _totalPrice = json['total_price'];
    _tax = json['tax'];
    _discount = json['discount'];
    _quantity = json['quantity'];
    _bonus =
        json['bonus'].runtimeType == int ? (json['bonus'] != 0) : json['bonus'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _stock = json['stock'] != null ? Stocks.fromJson(json['stock']) : null;
    _kitchen =
        json['kitchen'] != null ? KitchenModel.fromJson(json['kitchen']) : null;
    if (json['addons'] != null) {
      _addons = [];
      json['addons'].forEach((v) {
        _addons?.add(Addons.fromJson(v));
      });
    }
    _isChecked = false;
  }

  int? _id;
  int? _orderId;
  int? _stockId;
  num? _originPrice;
  num? _totalPrice;
  num? _tax;
  num? _discount;
  int? _quantity;
  bool? _bonus;
  String? _createdAt;
  String? _status;
  String? _updatedAt;
  Stocks? _stock;
  KitchenModel? _kitchen;
  List<Addons>? _addons;
  bool? _isChecked;

  OrderDetail copyWith({
    int? id,
    int? orderId,
    int? stockId,
    num? originPrice,
    num? totalPrice,
    num? tax,
    num? discount,
    int? quantity,
    bool? bonus,
    String? createdAt,
    String? updatedAt,
    String? status,
    Stocks? stock,
    KitchenModel? kitchen,
    List<Addons>? addons,
    bool? isChecked,
  }) =>
      OrderDetail(
        id: id ?? _id,
        orderId: orderId ?? _orderId,
        stockId: stockId ?? _stockId,
        originPrice: originPrice ?? _originPrice,
        totalPrice: totalPrice ?? _totalPrice,
        tax: tax ?? _tax,
        discount: discount ?? _discount,
        quantity: quantity ?? _quantity,
        bonus: bonus ?? _bonus,
        kitchen: kitchen ?? _kitchen,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        stock: stock ?? _stock,
        addons: addons ?? _addons,
        status: status ?? _status,
        isChecked: isChecked ?? _isChecked,
      );

  int? get id => _id;

  int? get orderId => _orderId;

  int? get stockId => _stockId;

  num? get originPrice => _originPrice;

  num? get totalPrice => _totalPrice;

  num? get tax => _tax;

  num? get discount => _discount;

  int? get quantity => _quantity;

  bool? get bonus => _bonus;

  String? get createdAt => _createdAt;

  String? get status => _status;

  String? get updatedAt => _updatedAt;

  Stocks? get stock => _stock;

  KitchenModel? get kitchen => _kitchen;

  List<Addons>? get addons => _addons;

  bool? get isChecked => _isChecked;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['stock_id'] = _stockId;
    map['origin_price'] = _originPrice;
    map['total_price'] = _totalPrice;
    map['tax'] = _tax;
    map['discount'] = _discount;
    map['quantity'] = _quantity;
    map['bonus'] = _bonus;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_stock != null) {
      map['stock'] = _stock?.toJson();
    }
    if (_kitchen != null) {
      map['kitchen'] = _kitchen?.toJson();
    }
    return map;
  }
}

class Transaction {
  Transaction({
    int? id,
    int? payableId,
    num? price,
    String? paymentTrxId,
    String? note,
    dynamic performTime,
    String? status,
    String? statusDescription,
    String? createdAt,
    String? updatedAt,
    PaymentData? paymentSystem,
  }) {
    _id = id;
    _payableId = payableId;
    _price = price;
    _paymentTrxId = paymentTrxId;
    _note = note;
    _performTime = performTime;
    _status = status;
    _statusDescription = statusDescription;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _paymentSystem = paymentSystem;
  }

  Transaction.fromJson(dynamic json) {
    _id = json['id'];
    _payableId = json['payable_id'];
    _price = json['price'];
    _paymentTrxId = json['payment_trx_id'];
    _note = json['note'];
    _performTime = json['perform_time'];
    _status = json['status'];
    _statusDescription = json['status_description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _paymentSystem = json['payment_system'] != null
        ? PaymentData.fromJson(json['payment_system'])
        : null;
  }

  int? _id;
  int? _payableId;
  num? _price;
  String? _paymentTrxId;
  String? _note;
  dynamic _performTime;
  String? _status;
  String? _statusDescription;
  String? _createdAt;
  String? _updatedAt;
  PaymentData? _paymentSystem;

  Transaction copyWith({
    int? id,
    int? payableId,
    num? price,
    String? paymentTrxId,
    String? note,
    dynamic performTime,
    String? status,
    String? statusDescription,
    String? createdAt,
    String? updatedAt,
    PaymentData? paymentSystem,
  }) =>
      Transaction(
        id: id ?? _id,
        payableId: payableId ?? _payableId,
        price: price ?? _price,
        paymentTrxId: paymentTrxId ?? _paymentTrxId,
        note: note ?? _note,
        performTime: performTime ?? _performTime,
        status: status ?? _status,
        statusDescription: statusDescription ?? _statusDescription,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        paymentSystem: paymentSystem ?? _paymentSystem,
      );

  int? get id => _id;

  int? get payableId => _payableId;

  num? get price => _price;

  String? get paymentTrxId => _paymentTrxId;

  String? get note => _note;

  dynamic get performTime => _performTime;

  String? get status => _status;

  String? get statusDescription => _statusDescription;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  PaymentData? get paymentSystem => _paymentSystem;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['payable_id'] = _payableId;
    map['price'] = _price;
    map['payment_trx_id'] = _paymentTrxId;
    map['note'] = _note;
    map['perform_time'] = _performTime;
    map['status'] = _status;
    map['status_description'] = _statusDescription;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_paymentSystem != null) {
      map['payment_system'] = _paymentSystem?.toJson();
    }
    return map;
  }
}

class OrderAddress {
  OrderAddress({
    String? address,
    String? office,
    String? house,
    String? floor,
  }) {
    _address = address;
    _office = office;
    _house = house;
    _floor = floor;
  }

  OrderAddress.fromJson(dynamic json) {
    _address = json['address'];
    _office = json['office'];
    _house = json['house'];
    _floor = json['floor'];
  }

  String? _address;
  String? _office;
  String? _house;
  String? _floor;

  OrderAddress copyWith({
    String? address,
    String? office,
    String? house,
    String? floor,
  }) =>
      OrderAddress(
        address: address ?? _address,
        office: office ?? _office,
        house: house ?? _house,
        floor: floor ?? _floor,
      );

  String? get address => _address;

  String? get office => _office;

  String? get house => _house;

  String? get floor => _floor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['office'] = _office;
    map['house'] = _house;
    map['floor'] = _floor;
    return map;
  }
}
