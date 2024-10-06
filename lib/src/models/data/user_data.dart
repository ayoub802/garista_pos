class UserData {
  UserData({
    int? id,
    String? firstName,
    String? lastName,
    int? phone,
    String? email,
    String? emailVerifiedAt,
    String? image,
    String? username,
    int? roleId,
    String? createdAt,
    String? updatedAt,
    String? language,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _phone = phone;
    _email = email;
    _emailVerifiedAt = emailVerifiedAt;
    _image = image;
    _username = username;
    _roleId = roleId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _language = language;
  }

  UserData.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _phone = json['phone'];
    _email = json['email'];
    _emailVerifiedAt = json['email_verified_at'];
    _image = json['image'];
    _username = json['username'];
    _roleId = json['role_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _language = json['language'];
  }

  int? _id;
  String? _firstName;
  String? _lastName;
  int? _phone;
  String? _email;
  String? _emailVerifiedAt;
  String? _image;
  String? _username;
  int? _roleId;
  String? _createdAt;
  String? _updatedAt;
  String? _language;

  int? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  int? get phone => _phone;
  String? get email => _email;
  String? get emailVerifiedAt => _emailVerifiedAt;
  String? get image => _image;
  String? get username => _username;
  int? get roleId => _roleId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get language => _language;

  UserData copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? phone,
    String? email,
    String? emailVerifiedAt,
    String? image,
    String? username,
    int? roleId,
    String? createdAt,
    String? updatedAt,
    String? language,
  }) {
    return UserData(
      id: id ?? _id,
      firstName: firstName ?? _firstName,
      lastName: lastName ?? _lastName,
      phone: phone ?? _phone,
      email: email ?? _email,
      emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
      image: image ?? _image,
      username: username ?? _username,
      roleId: roleId ?? _roleId,
      createdAt: createdAt ?? _createdAt,
      updatedAt: updatedAt ?? _updatedAt,
      language: language ?? _language,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['phone'] = _phone;
    map['email'] = _email;
    map['email_verified_at'] = _emailVerifiedAt;
    map['image'] = _image;
    map['username'] = _username;
    map['role_id'] = _roleId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['language'] = _language;
    return map;
  }
}
