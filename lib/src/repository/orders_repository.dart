import 'package:garista_pos/src/models/response/kitchen_orders_response.dart';
import 'package:garista_pos/src/models/response/orders_paginate_response.dart';
import 'package:garista_pos/src/models/response/single_order_response.dart';

import '../core/constants/app_constants.dart';
import '../core/handlers/handlers.dart';
import '../models/models.dart';

abstract class OrdersRepository {
  Future<ApiResult<CreateOrderResponse>> createOrder(List<CartItem> cartItems, double totalCost, int extraInfo, int restoId);

  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    OrderStatus? status,
    int? page,
    DateTime? from,
    DateTime? to,
    String? search,
  });

  Future<ApiResult<dynamic>> updateOrderStatus({
    required OrderStatus status,
    int? orderId,
  });

  Future<ApiResult<dynamic>> updateOrderDetailStatus({
    required String status,
    int? orderId,
  });

  Future<ApiResult<dynamic>> updateOrderStatusKitchen({
    required OrderStatus status,
    int? orderId,
  });

  Future<ApiResult<SingleOrderResponse>> getOrderDetails({int? orderId});

  Future<ApiResult<SingleKitchenOrderResponse>> getOrderDetailsKitchen(
      {int? orderId});

  Future<ApiResult<dynamic>> setDeliverMan(
      {required int orderId, required int deliverymanId});

  Future<ApiResult<dynamic>> deleteOrder({required int orderId});

  Future<ApiResult<OrderKitchenResponse>> getKitchenOrders({
    String? status,
    int? page,
    String? search,
  });
}
