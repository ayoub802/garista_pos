import 'dart:convert';

import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/response/kitchen_orders_response.dart';
import 'package:garista_pos/src/models/response/orders_paginate_response.dart';
import 'package:garista_pos/src/models/response/single_order_response.dart';
import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import 'package:garista_pos/src/core/di/dependency_manager.dart';
import '../../core/handlers/handlers.dart';
import '../../models/models.dart';
import '../repository.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  @override
  Future<ApiResult<CreateOrderResponse>> createOrder(List<CartItem> cartItems,
      double totalCost, int extraInfo, int restoId) async {
    try {
      final cartItemProduct = cartItems.map((item) {
        return {
          'type': item.type,
          'id': item.id,
          'quantity': item.quantity,
          'comment': item.comment ?? null,
          'toppings': item.toppings,
          'ingrediants': item
              .ingredients, // You may want to adjust this field based on your use case
          'extraVariant': item.extraVariants, // Same for this field
        };
      }).toList();

      final orderBody = {
        'total': totalCost,
        'status': 'New',
        'table_id': extraInfo,
        'resto_id': restoId,
        'cartItems': cartItemProduct,
      };
      print("The Order Data => ${cartItemProduct}");

      // Use the updated endpoint: /public/api/order/
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final data = jsonEncode(orderBody);
      final response = await client.post(
        '/api/order', // Updated endpoint
        data: data,
      );
      print("The Order Data => ${response.data}");

      // Check response and handle success/failure
      if (response.statusCode == 200) {
        // Assuming that CreateOrderResponse is your model for successful response
        await postOrderNotification(restoId, extraInfo);
        return ApiResult.success(
            data: CreateOrderResponse.fromJson(response.data));
      } else {
        // Handle error case
        return ApiResult.failure(
          error: AppHelpers.errorHandler("Failed to create order"),
        );
      }
    } catch (e) {
      // Catch and handle exceptions
      debugPrint('==> order create failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  Future<void> postOrderNotification(int restoId, int tableId) async {
    try {
      final notification = {
        'title': 'New Order',
        'status': 'Order',
        'resto_id': restoId,
        'table_id': tableId,
      };

      // Assuming you're using Dio for HTTP requests
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);

      // Post the notification to the backend
      final response = await client.post(
        '/api/notifications', // Endpoint to send notification
        data: jsonEncode(notification),
      );

      // Check if the notification request was successful
      if (response.statusCode == 200) {
        print('Notification successfully posted');
      } else {
        print('Failed to post notification: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and handle any exceptions
      print('Error posting notification: $e');
    }
  }

  @override
  Future<ApiResult<OrderKitchenResponse>> getKitchenOrders({
    String? status,
    int? page,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    final data = {
      if (page != null) 'page': page,
      if (status != null && TrKeys.all != status) 'status': status,
      if (TrKeys.all == status) 'statuses[0]': "accepted",
      if (TrKeys.all == status) 'statuses[1]': "cooking",
      if (TrKeys.all == status) 'statuses[2]': "ready",
      if (search != null) 'search': search,
      'perPage': 9,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/cook/orders/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrderKitchenResponse.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('==> get order $status failure: $e, $s');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<OrdersPaginateResponse>> getOrders({
    OrderStatus? status,
    int? page,
    DateTime? from,
    DateTime? to,
    String? search,
  }) async {
    String? statusText;
    switch (status) {
      case OrderStatus.accepted:
        statusText = 'Accepted';
        break;
      case OrderStatus.ready:
        statusText = 'Ready';
        break;
      case OrderStatus.completed:
        statusText = 'Completed';
        break;
      case OrderStatus.rejected:
        statusText = 'Rejected';
        break;
      case OrderStatus.preparing:
        statusText = 'Preparing';
        break;
      case OrderStatus.newO:
        statusText = 'New';
        break;
      default:
        statusText = null;
        break;
    }
    final data = {
      if (statusText != null) 'status': statusText,
    };
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get(
        '/api/order_resto_hundred/${LocalStorage.getRestaurant()?.id}',
        queryParameters: data,
      );
      return ApiResult.success(
        data: OrdersPaginateResponse.fromJson(response.data),
      );
    } catch (e, s) {
      debugPrint('==> get order with status $status failure: $e,$s');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> updateOrderStatus({
    required OrderStatus status,
    int? orderId,
  }) async {
    String? statusText;
    switch (status) {
      case OrderStatus.accepted:
        statusText = 'Accepted';
        break;
      case OrderStatus.ready:
        statusText = 'Ready';
        break;
      case OrderStatus.completed:
        statusText = 'Completed';
        break;
      case OrderStatus.rejected:
        statusText = 'Rejected';
        break;
      case OrderStatus.preparing:
        statusText = 'Preparing';
        break;
      case OrderStatus.newO:
        statusText = 'New';
        break;
      default:
        statusText = null;
        break;
    }
    final data = {'status': statusText};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        LocalStorage.getUser()?.id == TrKeys.waiter
            ? '/api/v1/dashboard/waiter/order/$orderId/status/update'
            : '/api/v1/dashboard/${LocalStorage.getUser()?.id}/order/$orderId/status',
        data: data,
      );
      return const ApiResult.success(
        data: null,
      );
    } catch (e) {
      debugPrint('==> update order status failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> updateOrderDetailStatus({
    required String status,
    int? orderId,
  }) async {
    final data = {'status': status};
    debugPrint('==> update order status data: ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        LocalStorage.getUser()?.id == TrKeys.waiter
            ? '/api/v1/dashboard/waiter/order/details/$orderId/status/update'
            : LocalStorage.getUser()?.id == TrKeys.cook
                ? '/api/v1/dashboard/cook/order-detail/$orderId/status/update'
                : '/api/v1/dashboard/${LocalStorage.getUser()?.id}/order/details/$orderId/status',
        data: data,
      );
      return const ApiResult.success(
        data: null,
      );
    } catch (e) {
      debugPrint('==> update order status failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> updateOrderStatusKitchen({
    required OrderStatus status,
    int? orderId,
  }) async {
    String? statusText;
    switch (status) {
      case OrderStatus.accepted:
        statusText = 'Accepted';
        break;
      case OrderStatus.ready:
        statusText = 'Ready';
        break;
      case OrderStatus.completed:
        statusText = 'Completed';
        break;
      case OrderStatus.rejected:
        statusText = 'Rejected';
        break;
      case OrderStatus.newO:
        statusText = 'New';
        break;
      default:
        statusText = null;
        break;
    }

    final data = {'status': statusText};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/cook/orders/$orderId/status/update',
        data: data,
      );
      return const ApiResult.success(
        data: null,
      );
    } catch (e) {
      debugPrint('==> update order status failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleOrderResponse>> getOrderDetails({int? orderId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);

      final response = await client.get('/api/order/$orderId');
      return ApiResult.success(
        data: SingleOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order details failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> setDeliverMan(
      {required int orderId, required int deliverymanId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final data = {
        'deliveryman': deliverymanId,
      };
      final response = await client.post(
          '/api/v1/dashboard/${LocalStorage.getUser()?.id}/order/$orderId/deliveryman',
          data: data);
      return ApiResult.success(
        data: SingleOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order details failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult> deleteOrder({required int orderId}) async {
    final data = {'ids[0]': orderId};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete(
        '/api/v1/dashboard/${LocalStorage.getUser()?.id}/orders/delete',
        queryParameters: data,
      );
      return const ApiResult.success(
        data: null,
      );
    } catch (e) {
      debugPrint('==> update order status failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
