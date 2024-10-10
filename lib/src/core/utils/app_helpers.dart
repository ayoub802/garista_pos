import 'dart:io';

import 'package:garista_pos/src/models/response/income_chart_response.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';
import '../../presentation/theme/theme.dart';
import '../constants/constants.dart';
import 'local_storage.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/riverpod/state/right_side_state.dart';

class AppHelpers {
  AppHelpers._();

  static num calculateTotalPrice(RightSideState state) {
    num totalPrice = 0;

    // Iterate over all bag products in the selected bag
    for (var bagProduct
        in state.bags[state.selectedBagIndex]?.bagProducts ?? []) {
      // Iterate over all carts within the current bag product
      for (var cart in bagProduct.carts ?? []) {
        // Sum up the price * quantity for each product
        num productPrice = num.tryParse(cart.price ?? '0') ??
            0; // Convert price to number safely
        totalPrice += productPrice * cart.quantity; // Multiply by quantity
      }
    }
    return totalPrice;
  }

  static String? getAppName() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'title') {
        return setting.value;
      }
    }
    return '';
  }

  static String? getRestaurnatName() {
    // Attempt to get the restaurant name from local storage
    final Restaurant? restaurant = LocalStorage
        .getRestaurant(); // Assuming this method exists and returns a Restaurant object
    if (restaurant != null && restaurant.name.isNotEmpty) {
      return restaurant.name; // Return the restaurant name if it exists
    }

    return 'Garista'; // Default return if no restaurant name is found
  }

  static String? getAppPhone() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'phone') {
        return setting.value;
      }
    }
    return '';
  }

  static bool getAutoPrint() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'auto_print_order') {
        return setting.value == "1";
      }
    }
    return false;
  }

  static bool isNumberRequiredToOrder() {
    return LocalStorage.getSettingsList()
            .firstWhere(
                (element) => element.key == "before_order_phone_required")
            .value ==
        '1';
  }

  static List<String> getMasterStatuses(String value) {
    switch (value) {
      case TrKeys.newKey:
        return [TrKeys.viewed, TrKeys.rejected];
      case TrKeys.viewed:
        return [TrKeys.newKey, TrKeys.rejected];
      case TrKeys.rejected:
        return [TrKeys.newKey, TrKeys.viewed];
      case 'excepted':
        return [TrKeys.newKey, TrKeys.viewed, TrKeys.rejected];
      default:
        return [];
    }
  }

  static Color getStatusColor(String? value) {
    switch (value) {
      case 'pending':
        return AppColors.pendingDark;
      case 'new':
        return AppColors.blueColor;
      case 'accepted':
        return AppColors.deepPurple;
      case 'ready':
      case 'progress':
        return AppColors.revenueColor;
      case 'on_a_way':
        return AppColors.black;
      case 'unpublished':
      case 'cooking':
        return AppColors.orange;
      case 'published':
      case 'active':
      case 'true':
      case 'delivered':
      case 'cash':
      case 'paid':
      case 'approved':
        return AppColors.green;
      case 'inactive':
      case 'false':
      case 'null':
      case 'canceled':
      case 'cancel':
        return AppColors.red;
      default:
        return AppColors.brandColor;
    }
  }

  static String? getInitialLocale() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'lang') {
        return setting.value;
      }
    }
    return null;
  }

  static double? getInitialLatitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return null;
        }
        final double? lat = double.tryParse(latString);
        return lat;
      }
    }
    return null;
  }

  static bool checkIsSvg(String? url) {
    if (url == null) {
      return false;
    }
    final length = url.length;
    return length > 3 ? url.substring(length - 3, length) == 'svg' : false;
  }

  static String dateFormat(DateTime? time) {
    return DateFormat("MMM d,yyyy").format(time ?? DateTime.now());
  }

  static String dateFormatDay(DateTime? time) {
    return DateFormat("yyyy-MM-dd").format(time ?? DateTime.now());
  }

  static getPhotoGallery(ValueChanged<String> onChange) async {
    if (Platform.isMacOS) {
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result?.files.first.path != null) {
          onChange.call(result?.files.first.path ?? "");
        }
      } catch (e, s) {
        debugPrint('===> trying to select file $e $s');
      }
    } else {
      XFile? file;
      try {
        file = await ImagePicker().pickImage(source: ImageSource.gallery);
      } catch (ex) {
        debugPrint('===> trying to select image $ex');
      }
      if (file != null) {
        onChange.call(file.path);
      }
    }
  }

  static double? getInitialLongitude() {
    final List<SettingsData> settings = LocalStorage.getSettingsList();
    for (final setting in settings) {
      if (setting.key == 'location') {
        final String? latString =
            setting.value?.substring(0, setting.value?.indexOf(','));
        if (latString == null) {
          return null;
        }
        final String? lonString = setting.value
            ?.substring((latString.length) + 2, setting.value?.length);
        if (lonString == null) {
          return null;
        }
        final double lon = double.parse(lonString);
        return lon;
      }
    }
    return null;
  }

  static void showAlertDialog({
    required BuildContext context,
    required Widget child,
    double radius = 16,
    Color? backgroundColor,
  }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.r),
      ),
      contentPadding: EdgeInsets.all(20.r),
      iconPadding: EdgeInsets.zero,
      content: child,
    );

    ///todo Directionality
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showSnackBar(BuildContext context, String title,
      {bool isIcon = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackBar = SnackBar(
      backgroundColor: AppColors.white,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width - 400.w, 0,
          32, MediaQuery.of(context).size.height - 160.h),
      content: Row(
        children: [
          if (isIcon)
            Padding(
              padding: EdgeInsets.only(right: 8.r),
              child: const Icon(
                FlutterRemix.checkbox_circle_fill,
                color: AppColors.brandColor,
              ),
            ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: AppHelpers.getTranslation(TrKeys.close),
        disabledTextColor: AppColors.black,
        textColor: AppColors.black,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String getTranslation(String trKey) {
    final Map<String, dynamic> translations = LocalStorage.getTranslations();
    if (AppConstants.autoTrn) {
      return (translations[trKey] ??
          (trKey.isNotEmpty
              ? trKey.replaceAll(".", " ").replaceAll("_", " ").replaceFirst(
                  trKey.substring(0, 1), trKey.substring(0, 1).toUpperCase())
              : ''));
    } else {
      return translations[trKey] ?? trKey;
    }
  }

  static ExtrasType getExtraTypeByValue(String? value) {
    switch (value) {
      case 'color':
        return ExtrasType.color;
      case 'text':
        return ExtrasType.text;
      case 'image':
        return ExtrasType.image;
      default:
        return ExtrasType.text;
    }
  }

  static DateTime getMinTime(String openTime) {
    final int openHour = int.parse(openTime.substring(3, 5)) == 0
        ? int.parse(openTime.substring(0, 2))
        : int.parse(openTime.substring(0, 2)) + 1;
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, openHour);
  }

  static DateTime getMaxTime(String closeTime) {
    final int closeHour = int.parse(closeTime.substring(0, 2));
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, closeHour);
  }

  static String changeStatusButtonText(String? value) {
    switch (value) {
      case 'new':
        return getTranslation(TrKeys.accepted);
      case 'accepted':
        return getTranslation(TrKeys.startCooking);
      case 'cooking':
        return getTranslation(TrKeys.ready);
      case 'ready':
        return getTranslation(TrKeys.ended);
      default:
        return getTranslation(value ?? '');
    }
  }

  static String getOrderStatusText(OrderStatus value) {
    switch (value) {
      case OrderStatus.newO:
        return "New";
      case OrderStatus.accepted:
        return "Accepted";
      case OrderStatus.cooking:
        return "cooking";
      case OrderStatus.ready:
        return "Ready";
      case OrderStatus.onAWay:
        return "on_a_way";
      case OrderStatus.completed:
        return "Completed";
      default:
        return "Rejected";
    }
  }

  static String getNextOrderStatus(String value) {
    switch (value) {
      case "New":
        return "Accepted";
      case "Accepted":
        return "cooking";
      case "cooking":
        return "Ready";
      case "Ready":
        return "Completed";
      default:
        return "Rejected";
    }
  }

  static OrderStatus getOrderStatus(String? value, {bool? isNextStatus}) {
    if (isNextStatus ?? false) {
      switch (value) {
        case 'New':
          return OrderStatus.accepted;
        case 'Accepted':
          return OrderStatus.cooking;
        case 'cooking':
          return OrderStatus.ready;
        case 'Ready':
          return OrderStatus.onAWay;
        case 'on_a_way':
          return OrderStatus.completed;
        default:
          return OrderStatus.rejected;
      }
    } else {
      switch (value) {
        case 'new':
          return OrderStatus.newO;
        case 'Accepted':
          return OrderStatus.accepted;
        case 'cooking':
          return OrderStatus.cooking;
        case 'Ready':
          return OrderStatus.ready;
        case 'on_a_way':
          return OrderStatus.onAWay;
        case 'Completed':
          return OrderStatus.completed;
        default:
          return OrderStatus.rejected;
      }
    }
  }

  static String getPinCodeText(int index) {
    switch (index) {
      case 0:
        return "1";
      case 1:
        return "2";
      case 2:
        return "3";
      case 3:
        return "4";
      case 4:
        return "5";
      case 5:
        return "6";
      case 6:
        return "7";
      case 7:
        return "8";
      case 8:
        return "9";
      case 10:
        return "0";
      default:
        return "0";
    }
  }

  static Widget getStatusType(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.r, horizontal: 10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: text == "New"
            ? AppColors.blue
            : text == "accept"
                ? Colors.deepPurple
                : text == "ready"
                    ? AppColors.rate
                    : AppColors.brandColor,
      ),
      child: Text(
        getTranslation(text),
        style: GoogleFonts.inter(
          fontSize: 12.sp,
          color: AppColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static PositionModel fixedTable(int n) {
    int top = 0;
    int left = 0;
    int right = 0;
    int bottom = 0;
    if (n == 1) {
      top = 1;
    } else if (n == 2) {
      top = 1;
      bottom = 1;
    } else if (n == 3) {
      top = 1;
      bottom = 1;
      left = 1;
    } else if (n == 4) {
      top = 1;
      bottom = 1;
      left = 1;
      right = 1;
    } else if (n > 4 && n <= 10) {
      top = ((n - 2) / 2).ceil();
      bottom = ((n - 2) / 2).floor();
      left = 1;
      right = 1;
    } else if (n > 10) {
      top = ((n - 4) / 2).ceil();
      bottom = ((n - 4) / 2).floor();
      left = 2;
      right = 2;
    }

    return PositionModel(top: top, left: left, right: right, bottom: bottom);
  }

  static String errorHandler(e) {
    try {
      return (e.runtimeType == DioException)
          ? ((e as DioException).response?.data["message"] == "Bad request."
              ? (e.response?.data["params"] as Map).values.first[0]
              : e.response?.data["message"])
          : e.toString();
    } catch (s) {
      try {
        return (e.runtimeType == DioException)
            ? ((e as DioException).response?.data.toString().substring(
                    (e.response?.data.toString().indexOf("<title>") ?? 0) + 7,
                    e.response?.data.toString().indexOf("</title") ?? 0))
                .toString()
            : e.toString();
      } catch (r) {
        try {
          return (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["error"]["message"])
                  .toString()
              : e.toString();
        } catch (f) {
          return e.toString();
        }
      }
    }
  }
}

extension Time on DateTime {
  bool toEqualTime(DateTime time) {
    if (time.year != year) {
      return false;
    } else if (time.month != month) {
      return false;
    } else if (time.day != day) {
      return false;
    }
    return true;
  }

  bool toEqualTimeWithHour(DateTime time) {
    if (time.year != year) {
      return false;
    } else if (time.month != month) {
      return false;
    } else if (time.day != day) {
      return false;
    } else if (time.hour != hour) {
      return false;
    }
    return true;
  }
}

extension FindPriceIndex on List<num> {
  double findPriceIndex(num price) {
    if (price != 0) {
      int startIndex = 0;
      int endIndex = 0;
      for (int i = 0; i < length; i++) {
        if ((this[i]) >= price.toInt()) {
          startIndex = i;
          break;
        }
      }
      for (int i = 0; i < length; i++) {
        if ((this[i]) <= price) {
          endIndex = i;
        }
      }
      if (startIndex == endIndex) {
        return length.toDouble();
      }

      num a = this[startIndex] - this[endIndex];
      num b = price - this[endIndex];
      num c = b / a;
      return startIndex.toDouble() + c;
    } else {
      return 0;
    }
  }
}

extension FindPrice on List<IncomeChartResponse> {
  num findPrice(DateTime time) {
    num price = 0;
    for (int i = 0; i < length; i++) {
      if (this[i].time!.toEqualTime(time)) {
        price = this[i].totalPrice ?? 0;
      }
    }
    return price;
  }

  num findPriceWithHour(DateTime time) {
    num price = 0;
    for (int i = 0; i < length; i++) {
      if (this[i].time!.toEqualTimeWithHour(time)) {
        price = this[i].totalPrice ?? 0;
      }
    }
    return price;
  }
}

extension BoolParsing on String {
  bool toBool() {
    return this == "true" || this == "1";
  }
}
