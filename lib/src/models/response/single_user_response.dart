import '../data/user_data.dart';

class SingleUserResponse {
  SingleUserResponse({
    bool? status,
    String? message,
    UserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  SingleUserResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  bool? _status;
  String? _message;
  UserData? _data;

  SingleUserResponse copyWith({
    bool? status,
    String? message,
    UserData? data,
  }) =>
      SingleUserResponse(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
