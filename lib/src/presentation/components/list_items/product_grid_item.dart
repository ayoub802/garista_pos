import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/utils.dart';
import '../../../models/models.dart';
import '../components.dart';
import '../../theme/theme.dart';

class ProductGridItem extends StatelessWidget {
  final ProductData product;
  final Function() onTap;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final bool isOutOfStock = product.stocks == null || product.stocks!.isEmpty;
    // final bool hasDiscount = isOutOfStock
    //     ? false
    //     : (product.stocks?[0].discount != null &&
    //         (product.stocks?[0].discount ?? 0) > 0);
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white,
        ),
        constraints: BoxConstraints(
          maxWidth: 227.r,
          maxHeight: 246.r,
        ),
        padding: REdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CommonImage(
                imageUrl: product.image1,
              ),
            ),
            16.verticalSpace,
            Text(
              '${product.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -14 * 0.02,
                color: AppColors.black,
              ),
            ),
            6.verticalSpace,
            Text(
              product.desc != null && product.desc!.length > 100
                  ? '${product.desc!.substring(0, 100)}...' // Safely access the string with '!'
                  : product.desc ?? '', // If null, display an empty string
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -14 * 0.02,
                color: AppColors.GaristaColorBg,
              ),
            ),
            8.verticalSpace,
            Row(
              children: [
                // Row(
                //   children: [
                //     Text(
                //       // AppHelpers.numberFormat(
                //       //     (product.stocks?.first.discount ?? 0) +
                //       //         (product.stocks?.first.totalPrice ?? 0)),
                //       "Number",
                //       style: GoogleFonts.inter(
                //         decoration: TextDecoration.lineThrough,
                //         fontSize: 16.sp,
                //         fontWeight: FontWeight.w600,
                //         color: AppColors.discountText,
                //         letterSpacing: -14 * 0.02,
                //       ),
                //     ),
                //     10.horizontalSpace,
                //   ],
                // ),
                Text(
                  '${product.price}',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    letterSpacing: -14 * 0.02,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
