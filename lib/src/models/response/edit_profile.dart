class EditProfile {
  String? first_name;
  String? last_name;
  String? phone;
  

  EditProfile(
      {this.first_name,
        this.last_name,
        this.phone,
        });

  EditProfile.fromJson(Map<String, dynamic> json) {
    first_name = json['first_name'];
    last_name = json['last_name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = first_name;
    data['last_name'] = last_name;
    data["phone"] = phone;
    return data;
  }
}