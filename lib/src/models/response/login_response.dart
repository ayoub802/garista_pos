import '../data/user_data.dart';

class LoginResponse {
  LoginResponse({
    bool? status,
    String? message,
    String? token,
    UserData? user,
    String? role,
  }) {
    _status = status;
    _message = message;
    _token = token;
    _user = user;
    _role = role;
  }

  LoginResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _token = json['token'];
    _user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    _role = json['role'];
  }

  bool? _status;
  String? _message;
  String? _token;
  UserData? _user;
  String? _role;

  LoginResponse copyWith(
          {String? timestamp,
          bool? status,
          String? message,
          UserData? user,
          String? role}) =>
      LoginResponse(
          status: status ?? _status,
          message: message ?? _message,
          user: user ?? _user,
          role: role ?? _role);

  bool? get status => _status;
  String? get message => _message;
  String? get token => _token;
  UserData? get user => _user;
  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['token'] = _token;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['role'] = _role;
    return map;
  }
}
