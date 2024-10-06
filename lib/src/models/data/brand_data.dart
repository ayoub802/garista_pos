class BrandData {
  BrandData({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? description,
    String? logo,
    String? address,
    String? phone,
    String? email,
    String? currency,
    String? websiteUrl,
    String? facebook,
    String? instagram,
    String? tiktok,
    String? youtube,
    String? snapchat,
    String? whatsapp,
    String? googleBusiness,
    String? trustpilotLink,
    String? wifiPassword,
    String? coverImage,
    String? facebookPixel,
    String? tiktokPixel,
    String? adsPixel,
    String? analytics,
    int? restoId,
    String? language,
  }) {
    _id = id;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _description = description;
    _logo = logo;
    _address = address;
    _phone = phone;
    _email = email;
    _currency = currency;
    _websiteUrl = websiteUrl;
    _facebook = facebook;
    _instagram = instagram;
    _tiktok = tiktok;
    _youtube = youtube;
    _snapchat = snapchat;
    _whatsapp = whatsapp;
    _googleBusiness = googleBusiness;
    _trustpilotLink = trustpilotLink;
    _wifiPassword = wifiPassword;
    _coverImage = coverImage;
    _facebookPixel = facebookPixel;
    _tiktokPixel = tiktokPixel;
    _adsPixel = adsPixel;
    _analytics = analytics;
    _restoId = restoId;
    _language = language;
  }

  BrandData.fromJson(dynamic json) {
    _id = json['id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _description = json['description'];
    _logo = json['logo'];
    _address = json['address'];
    _phone = json['phone'];
    _email = json['email'];
    _currency = json['currency'];
    _websiteUrl = json['website_url'];
    _facebook = json['facebook'];
    _instagram = json['instagram'];
    _tiktok = json['tiktok'];
    _youtube = json['youtube'];
    _snapchat = json['snapchat'];
    _whatsapp = json['whatsapp'];
    _googleBusiness = json['google_buss'];
    _trustpilotLink = json['trustpilot_link'];
    _wifiPassword = json['wifi_pass'];
    _coverImage = json['cover_image'];
    _facebookPixel = json['facebook_pixel'];
    _tiktokPixel = json['tiktok_pixel'];
    _adsPixel = json['ads_pixel'];
    _analytics = json['anylytics'];
    _restoId = json['resto_id'];
    _language = json['language'];
  }

  int? _id;
  String? _createdAt;
  String? _updatedAt;
  String? _description;
  String? _logo;
  String? _address;
  String? _phone;
  String? _email;
  String? _currency;
  String? _websiteUrl;
  String? _facebook;
  String? _instagram;
  String? _tiktok;
  String? _youtube;
  String? _snapchat;
  String? _whatsapp;
  String? _googleBusiness;
  String? _trustpilotLink;
  String? _wifiPassword;
  String? _coverImage;
  String? _facebookPixel;
  String? _tiktokPixel;
  String? _adsPixel;
  String? _analytics;
  int? _restoId;
  String? _language;

  BrandData copyWith({
    int? id,
    String? createdAt,
    String? updatedAt,
    String? description,
    String? logo,
    String? address,
    String? phone,
    String? email,
    String? currency,
    String? websiteUrl,
    String? facebook,
    String? instagram,
    String? tiktok,
    String? youtube,
    String? snapchat,
    String? whatsapp,
    String? googleBusiness,
    String? trustpilotLink,
    String? wifiPassword,
    String? coverImage,
    String? facebookPixel,
    String? tiktokPixel,
    String? adsPixel,
    String? analytics,
    int? restoId,
    String? language,
  }) =>
      BrandData(
        id: id ?? _id,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        description: description ?? _description,
        logo: logo ?? _logo,
        address: address ?? _address,
        phone: phone ?? _phone,
        email: email ?? _email,
        currency: currency ?? _currency,
        websiteUrl: websiteUrl ?? _websiteUrl,
        facebook: facebook ?? _facebook,
        instagram: instagram ?? _instagram,
        tiktok: tiktok ?? _tiktok,
        youtube: youtube ?? _youtube,
        snapchat: snapchat ?? _snapchat,
        whatsapp: whatsapp ?? _whatsapp,
        googleBusiness: googleBusiness ?? _googleBusiness,
        trustpilotLink: trustpilotLink ?? _trustpilotLink,
        wifiPassword: wifiPassword ?? _wifiPassword,
        coverImage: coverImage ?? _coverImage,
        facebookPixel: facebookPixel ?? _facebookPixel,
        tiktokPixel: tiktokPixel ?? _tiktokPixel,
        adsPixel: adsPixel ?? _adsPixel,
        analytics: analytics ?? _analytics,
        restoId: restoId ?? _restoId,
        language: language ?? _language,
      );

  int? get id => _id;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get description => _description;
  String? get logo => _logo;
  String? get address => _address;
  String? get phone => _phone;
  String? get email => _email;
  String? get currency => _currency;
  String? get websiteUrl => _websiteUrl;
  String? get facebook => _facebook;
  String? get instagram => _instagram;
  String? get tiktok => _tiktok;
  String? get youtube => _youtube;
  String? get snapchat => _snapchat;
  String? get whatsapp => _whatsapp;
  String? get googleBusiness => _googleBusiness;
  String? get trustpilotLink => _trustpilotLink;
  String? get wifiPassword => _wifiPassword;
  String? get coverImage => _coverImage;
  String? get facebookPixel => _facebookPixel;
  String? get tiktokPixel => _tiktokPixel;
  String? get adsPixel => _adsPixel;
  String? get analytics => _analytics;
  int? get restoId => _restoId;
  String? get language => _language;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['description'] = _description;
    map['logo'] = _logo;
    map['address'] = _address;
    map['phone'] = _phone;
    map['email'] = _email;
    map['currency'] = _currency;
    map['website_url'] = _websiteUrl;
    map['facebook'] = _facebook;
    map['instagram'] = _instagram;
    map['tiktok'] = _tiktok;
    map['youtube'] = _youtube;
    map['snapchat'] = _snapchat;
    map['whatsapp'] = _whatsapp;
    map['google_buss'] = _googleBusiness;
    map['trustpilot_link'] = _trustpilotLink;
    map['wifi_pass'] = _wifiPassword;
    map['cover_image'] = _coverImage;
    map['facebook_pixel'] = _facebookPixel;
    map['tiktok_pixel'] = _tiktokPixel;
    map['ads_pixel'] = _adsPixel;
    map['anylytics'] = _analytics;
    map['resto_id'] = _restoId;
    map['language'] = _language;
    return map;
  }
}
