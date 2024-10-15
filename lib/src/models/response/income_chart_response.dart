import 'dart:convert';

List<IncomeChartResponse> incomeChartResponseFromJson(String str) =>
    List<IncomeChartResponse>.from(
        json.decode(str).map((x) => IncomeChartResponse.fromJson(x)));

String incomeChartResponseToJson(List<IncomeChartResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IncomeChartResponse {
  DateTime? time;
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

    factory IncomeChartResponse.fromJson(Map<String, dynamic> json) {
     DateTime? parsedTime;

    if (json["time"] != null) {
      // Parse as DateTime when the time string is in full date format
      parsedTime = DateTime.tryParse(json["time"]);
      if (parsedTime == null) {
        // Handle the case for H:i:s if not a full date
        DateTime now = DateTime.now();
        final timeParts = json["time"].toString().split(':');
        if (timeParts.length == 3) {
          parsedTime = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(timeParts[0]), // Hours
            int.parse(timeParts[1]), // Minutes
            int.parse(timeParts[2]), // Seconds
          );
        }
      }
    }

      print("Parsed time: $parsedTime from ${json["time"]}");
      
      return IncomeChartResponse(
        time: parsedTime,
        totalPrice: json["total_price"] != null
            ? num.tryParse(json["total_price"].toString()) // Safely parse as a number
            : null,
      );
    }

  Map<String, dynamic> toJson() => {
        "time": time != null ? time!.toIso8601String() : null,
        "total_price": totalPrice,
      };

    static DateTime? _parseTime(String timeStr) {
      try {
        if (timeStr.length == 7) { // Handle "YYYY-MM" format
          return DateTime.tryParse("$timeStr-01")?.toLocal(); // Add '-01' to make it a full date
        } else if (timeStr.length == 10) { // Handle "YYYY-MM-DD" format
          return DateTime.tryParse(timeStr)?.toLocal();
        }
        return null; // Return null if format unrecognized
      } catch (e) {
        return null; // Handle parsing errors gracefully
      }
    }
}
