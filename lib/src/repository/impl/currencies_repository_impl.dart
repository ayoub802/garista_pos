import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:garista_pos/src/core/di/dependency_manager.dart';
import '../../core/handlers/handlers.dart';
import '../../models/models.dart';
import '../repository.dart';
import '../../core/constants/constants.dart';

class CurrenciesRepositoryImpl extends CurrenciesRepository {
  @override
  Future<ApiResult<CurrenciesResponse>> getCurrencies() async {
    try {
      final client = dioHttp.client(
          requireAuth: false, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.get('/api/currencies');
      return ApiResult.success(
        data: CurrenciesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get currencies failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }
}
