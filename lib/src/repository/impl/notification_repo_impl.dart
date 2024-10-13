import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/data/count_of_notifications_data.dart';
import 'package:garista_pos/src/models/data/notification_data.dart';
import 'package:garista_pos/src/models/data/notification_transactions_data.dart';
import 'package:garista_pos/src/models/data/read_one_notification_data.dart';
import 'package:garista_pos/src/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:garista_pos/src/core/di/dependency_manager.dart';
import '../../core/handlers/handlers.dart';
import '../../core/constants/constants.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  @override
  Future<ApiResult<NotificationResponse>> getNotifications({
    int? page,
  }) async {
    final data = {
      if (page != null) 'page': page,
      'column': 'created_at',
      'sort': 'desc',
      'perPage': 5,
    };
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get(
        '/api/getNotificationsPOS/${LocalStorage.getRestaurant()?.id}',
        queryParameters: data,
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> readAll() async {
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.post(
        '/api/notifications/mark-as-read/${LocalStorage.getRestaurant()?.id}',
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<ReadOneNotificationResponse>> readOne({int? id}) async {
    final data = {
      if (id != null) '$id': id,
      // 'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.post(
        '/api/notifications/mark-as-readbyID/$id',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ReadOneNotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> showSingleUser({int? id}) async {
    final data = {
      if (id != null) '$id': id,
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.post(
        '/api/getNotificationsByID/$id',
        queryParameters: data,
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<NotificationResponse>> getAllNotifications() async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale ?? 'en',
    };
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get(
        '/api/getAllNotifications/${LocalStorage.getRestaurant()?.id}',
        queryParameters: data,
      );
      return ApiResult.success(
        data: NotificationResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<ApiResult<CountNotificationModel>> getCount() async {
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get(
        '/api/notifications/count/${LocalStorage.getRestaurant()?.id}',
      );
      return ApiResult.success(
        data: CountNotificationModel.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get notification failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
