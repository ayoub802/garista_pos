import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../core/handlers/handlers.dart';
import '../../models/models.dart';
import '../repository.dart';
import '../../core/constants/constants.dart';

class BrandsRepositoryImpl extends BrandsRepository {
  @override
  Future<ApiResult<BrandsPaginateResponse>> searchBrands(String? query) async {
    final data = {'search': query};
    try {
      final client =
          dioHttp.client(requireAuth: true, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get(
        '/api/infos/${LocalStorage.getRestaurant()?.id}',
        queryParameters: data,
      );

      print("The Info Data => ${response.data}");
      return ApiResult.success(
        data: BrandsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> search brands failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
