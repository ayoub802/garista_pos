import 'dart:convert';

List<IncomeChartResponse> incomeChartResponseFromJson(String str) =>
    List<IncomeChartResponse>.from(
        json.decode(str).map((x) => IncomeChartResponse.fromJson(x)));

String incomeChartResponseToJson(List<IncomeChartResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncomeChartResponse {
  dynamic? time;
  num? totalPrice;

  IncomeChartResponse({
    this.time,
    this.totalPrice,
  });

  IncomeChartResponse copyWith({
    dynamic? time,
    num? totalPrice,
  }) =>
      IncomeChartResponse(
        time: time ?? this.time,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  factory IncomeChartResponse.fromJson(Map<String, dynamic> json) =>
      IncomeChartResponse(
        time: json["time"] == null ? null : _parseTime(json["time"].toString()),
        totalPrice: json["total_price"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "time": time is DateTime
            ? "${time!.year.toString().padLeft(4, '0')}-${time!.month.toString().padLeft(2, '0')}-${time!.day.toString().padLeft(2, '0')}"
            : time
                .toString(), // Ensure correct formatting if it's not a full DateTime
        "total_price": totalPrice,
      };
  static DateTime? _parseTime(String timeStr) {
    try {
      // If the string is in "YYYY-MM-DD" format, use DateTime.parse
      if (timeStr.length == 10) {
        return DateTime.tryParse(timeStr)?.toLocal();
      }
      // If the string is in "YYYY-MM" format, add a day (default to the first day of the month)
      else if (timeStr.length == 7) {
        return DateTime.tryParse(timeStr + "-01")?.toLocal();
      }
      return null; // Return null if the format is unrecognized
    } catch (e) {
      return null; // Handle any parsing errors gracefully
    }
  }
}
