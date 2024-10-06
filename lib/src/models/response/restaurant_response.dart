import '../data/restaurant_dart.dart'; // Import the Restaurant model

class RestaurantResponse {
  RestaurantResponse({
    bool? status,
    String? message,
    Restaurant? restaurant,
  }) {
    _status = status;
    _message = message;
    _restaurant = restaurant;
  }

  // Construct from JSON
  RestaurantResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
  }

  bool? _status;
  String? _message;
  Restaurant? _restaurant;

  // CopyWith method
  RestaurantResponse copyWith({
    bool? status,
    String? message,
    Restaurant? restaurant,
  }) =>
      RestaurantResponse(
        status: status ?? _status,
        message: message ?? _message,
        restaurant: restaurant ?? _restaurant,
      );

  // Getters
  bool? get status => _status;
  String? get message => _message;
  Restaurant? get restaurant => _restaurant;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_restaurant != null) {
      map['restaurant'] = _restaurant?.toJson();
    }
    return map;
  }
}
