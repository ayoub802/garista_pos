import 'package:garista_pos/src/models/response/product_calculate_response.dart';

import '../core/handlers/handlers.dart';
import '../models/models.dart';

abstract class ProductsRepository {
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? query,
    int? categoryId,
  });

  // Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
  //     List<BagProductData> bagProducts, String type,
  //     {String? coupon});
}
