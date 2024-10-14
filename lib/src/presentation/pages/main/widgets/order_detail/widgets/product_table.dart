import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:garista_pos/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart' as flutter_widgets;
class ProductTable extends StatelessWidget {
  final OrderData? orderData;
  final Function(int?, String) onEdit;

  const ProductTable({super.key, required this.orderData, required this.onEdit});

    num safeConvertToNum(dynamic value) {
      if (value is num) {
        return value; // Already a num
      } else if (value is String) {
        return num.tryParse(value) ?? 0; // Parse string or return 0
      }
      return 0; // Default case for null or unsupported types
    }
  @override
  Widget build(BuildContext context) {
    return flutter_widgets.Table(
      columnWidths: {
        0: FixedColumnWidth(66.w),
        1: FixedColumnWidth(168.w),
        2: FixedColumnWidth(80.w),
        3: FixedColumnWidth(120.w),
        4: FixedColumnWidth(200.w),
        5: FixedColumnWidth(200.w),
        6: FixedColumnWidth(200.w),
      },
      border: TableBorder.all(color: AppColors.transparent),
      children: [
        TableRow(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.id),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.productName),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.quantity),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.totalPrice),
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Toppings",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ingrediants",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Extra Varaints",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                )
              ],
            ),
          ],
        ),
        for (int i = 0; i < (orderData?.dishes?.length ?? 0); i++)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      "#${orderData?.dishes?[i].id ?? 0}",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.iconColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      (orderData?.dishes?[i].name ?? ""),
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.iconColor,
                        letterSpacing: -0.3,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      "${(orderData?.dishes?[i].quantity ?? 1)}",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.iconColor,
                        letterSpacing: -0.3,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: REdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text("${(orderData?.dishes?[i].quantity ?? 1) * safeConvertToNum(orderData?.dishes?[i].price)} ${LocalStorage.getBrand()?.currency}",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.iconColor,
                        letterSpacing: -0.3,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    // Display toppings
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        orderData?.dishes?[i].toppings?.length ?? 0,
                        (j) {
                          final topping = orderData?.dishes?[i].toppings?[j];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0), // Add space between toppings
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Topping Name
                                Text(
                                  "${topping?.name} : " ?? "",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: AppColors.iconColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                10.verticalSpace,
                                // Topping Options
                                ...?topping?.options?.map((option) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 14),
                                      child:  Text(
                                        "${option.name} - ${option.price ?? 0}",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: AppColors.iconColor,
                                          letterSpacing: -0.3,
                                        ),
                                      )
                                    );
                                    }).toList()  
                                 
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    // Display toppings
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        orderData?.dishes?[i].ingrediants?.length ?? 0,
                        (j) {
                          final ingrediant = orderData?.dishes?[i].ingrediants?[j];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.0), // Add space between ingrediants
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ingrediant Name
                                Text(
                                  "${ingrediant?.name}" ?? "",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    color: AppColors.iconColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(),
                                  // Display toppings
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List.generate(
                                      orderData?.dishes?[i].extraVariants?.length ?? 0,
                                      (j) {
                                        final extravariant = orderData?.dishes?[i].extraVariants?[j];
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 8.0), // Add space between extravariants
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // extravariant Name
                                              Text(
                                                "${extravariant?.name} : " ?? "",
                                                style: GoogleFonts.inter(
                                                  fontSize: 16.sp,
                                                  color: AppColors.iconColor,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: -0.3,
                                                ),
                                              ),
                                              10.verticalSpace,
                                              // extravariant Options
                                              ...?extravariant?.options?.map((option) {
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 14),
                                                    child:  Text(
                                                      "${option.name} - ${option.price ?? 0}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14.sp,
                                                        color: AppColors.iconColor,
                                                        letterSpacing: -0.3,
                                                      ),
                                                    )
                                                  );
                                                  }).toList()  
                                              
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ],
          ),
     
          ],
    );
  }
}
