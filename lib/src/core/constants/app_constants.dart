class AppConstants {
  AppConstants._();
  static const bool autoTrn = true;
  static const bool isDemo = true;

  /// shared preferences keys
  static const String keyLangSelected = 'keyLangSelected';
  static const String keyRestaurant = 'keyRestaurant';
  static const String keyRestaurantList = 'keyRestaurantList';
  static const String keybrand = 'keybrand';
  static const String keyLanguageData = 'keyLanguageData';
  static const String keyToken = 'keyToken';
  static const String keyGlobalSettings = 'keyGlobalSettings';
  static const String keyActiveLocale = 'keyActiveLocale';
  static const String keyTranslations = 'keyTranslations';
  static const String keySelectedCurrency = 'keySelectedCurrency';
  static const String keyLangLtr = 'keyLangLtr';
  static const String keyBags = 'keyBags';
  static const String keyUser = 'keyUser';
  static const String pinCode = 'pinCode';
  static const String demoSellerLogin = 'admin@gmail.com';
  static const String demoSellerPassword = 'password';
  static const String demoCookerLogin = 'cook@githubit.com';
  static const String demoCookerPassword = 'cook';
  static const String demoWaiterLogin = 'waiter@githubit.com';
  static const String demoWaiterPassword = 'githubit';
  static const String keySystemLanguage = 'keySystemLanguage';
  static const Duration refreshTime = Duration(seconds: 10);
  static const double demoLatitude = 41.304223;
  static const double demoLongitude = 69.2348277;
  static const double pinLoadingMin = 0.116666667;
  static const double pinLoadingMax = 0.611111111;
  static const Duration animationDuration = Duration(milliseconds: 375);

  static const double radius = 12;
}

enum DropDownType { categories, users }

enum ExtrasType { color, text, image }

enum ChairPosition { top, bottom, left, right }

enum ProductStatus { published, pending, unpublished }

enum UploadType {
  extras,
  brands,
  categories,
  shopsLogo,
  shopsBack,
  products,
  reviews,
  users,
  discounts
}

enum OrderStatus {
  newOrder,
  accepted,
  cooking,
  ready,
  onAWay,
  delivered,
  canceled,
}
