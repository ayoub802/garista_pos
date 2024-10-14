class IncomeCartResponse {
  dynamic? revenue;
  dynamic? revenuePercent;
  dynamic? orders;
  dynamic? ordersPercent;
  num? average;
  dynamic? averagePercent;
  String? revenueType;
  String? ordersType;
  String? averageType;

  IncomeCartResponse({
    this.revenue,
    this.revenuePercent,
    this.orders,
    this.ordersPercent,
    this.average,
    this.averagePercent,
    this.revenueType,
    this.ordersType,
    this.averageType,
  });

  IncomeCartResponse copyWith({
    dynamic? revenue,
    dynamic? revenuePercent,
    dynamic? orders,
    dynamic? ordersPercent,
    num? average,
    dynamic? averagePercent,
    String? revenueType,
    String? ordersType,
    String? averageType,
  }) =>
      IncomeCartResponse(
        revenue: revenue ?? this.revenue,
        revenuePercent: revenuePercent ?? this.revenuePercent,
        orders: orders ?? this.orders,
        ordersPercent: ordersPercent ?? this.ordersPercent,
        average: average ?? this.average,
        averagePercent: averagePercent ?? this.averagePercent,
        revenueType: revenueType ?? this.revenueType,
        ordersType: ordersType ?? this.ordersType,
        averageType: averageType ?? this.averageType,
      );

  factory IncomeCartResponse.fromJson(Map<String, dynamic> json) =>
      IncomeCartResponse(
        revenue: json["revenue"],
        revenuePercent:
            json["revenuePercent"], // Adjusted to match the response
        orders: json["orders"],
        ordersPercent: json["ordersPercent"], // Adjusted to match the response
        average: json["average"],
        averagePercent:
            json["averagePercent"], // Adjusted to match the response
        revenueType: json["revenueType"], // Adjusted to match the response
        ordersType: json["ordersType"], // Adjusted to match the response
        averageType: json["averageType"], // Adjusted to match the response
      );

  Map<String, dynamic> toJson() => {
        "revenue": revenue,
        "revenuePercent": revenuePercent,
        "orders": orders,
        "ordersPercent": ordersPercent,
        "average": average,
        "averagePercent": averagePercent,
      };
}
