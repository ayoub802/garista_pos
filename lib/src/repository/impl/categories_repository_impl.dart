import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:flutter/material.dart';

import 'package:garista_pos/src/core/di/dependency_manager.dart';
import '../../core/handlers/handlers.dart';
import '../../core/utils/utils.dart';
import '../../models/models.dart';
import '../repository.dart';

class CategoriesRepositoryImpl extends CategoriesRepository {
  @override
  Future<ApiResult<CategoriesPaginateResponse>> searchCategories(
    String? query,
  ) async {
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client
          .get('/api/categories/${LocalStorage.getRestaurant()?.id}');

      print("The Response of Categories => ${response.data}");
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e, stackTrace) {
      debugPrint('==> get categories failure: $e');
      debugPrint('StackTrace: $stackTrace');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
