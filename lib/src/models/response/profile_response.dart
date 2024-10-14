import '../data/user_data.dart';

class ProfileResponse {
  
  ProfileResponse({
    UserData? data,
    }) {
    _data = data;
  }

  ProfileResponse.fromJson(dynamic json) {
     if (json['data'] != null) {
      _data = UserData.fromJson(json['data']);
      print("Data from JSON: ${json['data']}");
    } else if (json['user'] != null) {
      _data = UserData.fromJson(json['user']);
    } else {
      print("No user or data field in JSON");
    }
  }

  UserData? _data;


  ProfileResponse copyWith({UserData? data}) =>
      ProfileResponse(data: data ?? _data);

  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map.addAll(_data?.toJson() ?? {});
    }
    return map;
  }
}
