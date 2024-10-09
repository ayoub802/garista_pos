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
  Future<ApiResult<CreateOrderResponse>> createOrder(
      OrderBodyData orderBody) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final data = orderBody.toJson();
      debugPrint('==> order create data: ${jsonEncode(data)}');
      final response = await client.post(
        '/api/v1/dashboard/${LocalStorage.getUser()?.id}/orders',
        data: data,
      );

      return ApiResult.success(
        data: CreateOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> order create failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
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
        '/api/order_resto/${LocalStorage.getRestaurant()?.id}',
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
      final data = {
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      final response = await client.get(
          '/api/v1/dashboard/${LocalStorage.getUser()?.id}/orders/$orderId',
          queryParameters: data);
      return ApiResult.success(
        data: SingleOrderResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get order details failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<SingleKitchenOrderResponse>> getOrderDetailsKitchen(
      {int? orderId}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final data = {
        'lang': LocalStorage.getLanguage()?.locale ?? 'en',
      };
      final response = await client
          .get('/api/v1/dashboard/cook/orders/$orderId', queryParameters: data);
      return ApiResult.success(
        data: SingleKitchenOrderResponse.fromJson(response.data),
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
