import '../core/constants/app_constants.dart';
import '../core/handlers/api_result.dart';
import '../models/response/stock_paginate_response.dart';

abstract class StockRepository {
  Future<ApiResult<StockPaginateResponse>> getStocks({
    required int page,
    int? categoryId,
    String? query,
    ProductStatus? status,
    int? brandId,
    bool? isNew,
    List<int>? brandIds,
    List<int>? categoryIds,
    List<int>? extrasId,
    num? priceTo,
    num? priceFrom,
  });
}
