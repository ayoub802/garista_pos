import 'package:garista_pos/src/models/data/addons_data.dart';
import 'package:garista_pos/src/models/data/product_data.dart';
import 'package:garista_pos/src/models/data/bag_data.dart';
import 'package:garista_pos/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:garista_pos/src/presentation/components/common_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import '../../../core/utils/utils.dart';
import '../../theme/theme.dart';

class CartOrderItem extends StatelessWidget {
  final List<CartProductData>? cart;
  final String? symbol;
  final VoidCallback add;
  final VoidCallback remove;
  final VoidCallback delete;
  final bool isActive;
  final bool isOwn;

  const CartOrderItem({
    super.key,
    required this.add,
    required this.remove,
    required this.cart,
    required this.delete,
    this.isActive = true,
    this.isOwn = true,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context) {
    num sumPrice = 0;
    num disSumPrice = 0;

    if (cart != null) {
      for (CartProductData product in cart!) {
        String toppings = product.selectedToppings
            ?.map((topping) => topping.toString())
            .join(', ') ?? 'No toppings';
        print("The Cart Product => ${product.name} has toppings => $toppings");
      }
    }
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.12,
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () {
                    Slidable.of(context)?.close();
                    delete.call();
                  },
                  child: Container(
                    width: 50.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      FlutterRemix.close_fill,
                      color: AppColors.white,
                      size: 24.r,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          isActive
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      // Loop through the cart products and display each product
                      for (CartProductData product in cart ?? [])
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.r, vertical: 8.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Displaying product name
                                    RichText(
                                      text: TextSpan(
                                        text: product
                                            .name, // Accessing product name
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: AppColors.black,
                                        ),
                                        children: [
                                          // Displaying extras (if any)
                                          if (product.desc != null)
                                            TextSpan(
                                              text:
                                                  " (${product.desc})", // Accessing product description
                                              style: GoogleFonts.inter(
                                                fontSize: 14.sp,
                                                color: AppColors.hintColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    8.verticalSpace,

                                    // Displaying product price
                                    // Text(
                                    //   intl.NumberFormat.currency(
                                    //     symbol: symbol ??
                                    //         LocalStorage.getSelectedCurrency()
                                    //             .type,
                                    //   ).format(product
                                    //       .price), // Accessing product price
                                    //   style: GoogleFonts.inter(
                                    //     fontSize: 12.sp,
                                    //     color: AppColors.unselectedTab,
                                    //   ),
                                    // ),
                                    16.verticalSpace,
                                  ],
                                ),
                              ),
                              // Displaying quantity
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 10.h, horizontal: 16.w),
                              //   decoration: BoxDecoration(
                              //     color: AppColors.brandColor,
                              //     borderRadius: BorderRadius.circular(10.r),
                              //   ),
                              //   child: Text(
                              //     "${product.quantity}x", // Accessing product quantity
                              //     style: GoogleFonts.inter(
                              //       fontSize: 14.sp,
                              //       color: AppColors.black,
                              //       fontWeight: FontWeight.w700,
                              //     ),
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 16.w),
                                    decoration: BoxDecoration(
                                        color: AppColors.GaristaColorBg,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.r),
                                            bottomRight:
                                                Radius.circular(10.r))),
                                    child: Text(
                                      "${(product?.quantity ?? 1).toString()}x",
                                      style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  24.horizontalSpace,
                                  GestureDetector(
                                    onTap: () {
                                          remove(); // Ensure the `remove` function is being triggered
                                        },
                                    child: AnimationButtonEffect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.removeButtonColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.r),
                                            bottomLeft: Radius.circular(10.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 20.w),
                                          child: const Icon(
                                            Icons.remove,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  4.horizontalSpace,
                                  GestureDetector(
                                    onTap: add,
                                    child: AnimationButtonEffect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.addButtonColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.r),
                                            bottomRight: Radius.circular(10.r),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.h, horizontal: 20.w),
                                          child: const Icon(
                                            Icons.add,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // const Spacer(),
                                  16.horizontalSpace,
                                ],
                              ),
                            ],
                          ),
                        ),
                      // Add more UI components or actions if needed...
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.all(16.r),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.r),
                      ),
                      border: Border.all(color: AppColors.borderColor)),
                  // child: Column(
                  //   children: [
                  //     Row(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisSize: MainAxisSize.max,
                  //             mainAxisAlignment: MainAxisAlignment.start,
                  //             children: [
                  //               RichText(
                  //                   text: TextSpan(
                  //                       text: cart?.stock?.product?.translation
                  //                           ?.title,
                  //                       style: GoogleFonts.inter(
                  //                         fontSize: 16,
                  //                         color: AppColors.black,
                  //                       ),
                  //                       children: [
                  //                     if (cart?.stock?.extras?.isNotEmpty ??
                  //                         false)
                  //                       TextSpan(
                  //                         text:
                  //                             " (${cart?.stock?.extras?.first.value ?? ""})",
                  //                         style: GoogleFonts.inter(
                  //                           fontSize: 14,
                  //                           color: AppColors.hintColor,
                  //                         ),
                  //                       )
                  //                   ])),
                  //               8.verticalSpace,
                  //               for (Addons e in (cart?.addons ?? []))
                  //                 Text(
                  //                   "${e.product?.translation?.title ?? ""} ( ${intl.NumberFormat.currency(
                  //                     symbol: symbol ??
                  //                         LocalStorage.getSelectedCurrency()
                  //                             .type,
                  //                   ).format((e.price ?? 0) / (e.quantity ?? 1))} x ${(e.quantity ?? 1)} )",
                  //                   style: GoogleFonts.inter(
                  //                     fontSize: 13.sp,
                  //                     color: AppColors.black,
                  //                   ),
                  //                 ),
                  //               8.verticalSpace,
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     "${intl.NumberFormat.currency(
                  //                       symbol: symbol ??
                  //                           LocalStorage.getSelectedCurrency()
                  //                               .type,
                  //                     ).format((cart?.totalPrice ?? 1) / (cart?.quantity ?? 1))} X ${cart?.quantity ?? 1}",
                  //                     style: GoogleFonts.inter(
                  //                       fontSize: 14,
                  //                       color: AppColors.black,
                  //                     ),
                  //                   ),
                  //                   const Spacer(),
                  //                   !(cart?.stock?.bonus != null)
                  //                       ? Column(
                  //                           children: [
                  //                             Text(
                  //                               intl.NumberFormat.currency(
                  //                                 symbol: symbol ??
                  //                                     LocalStorage
                  //                                             .getSelectedCurrency()
                  //                                         .type,
                  //                               ).format(
                  //                                   (cart?.discount ?? 0) != 0
                  //                                       ? disSumPrice
                  //                                       : sumPrice),
                  //                               style: GoogleFonts.inter(
                  //                                   fontWeight: FontWeight.w600,
                  //                                   fontSize:
                  //                                       (cart?.discount ?? 0) !=
                  //                                               0
                  //                                           ? 12
                  //                                           : 16,
                  //                                   color: AppColors.black,
                  //                                   decoration:
                  //                                       (cart?.discount ?? 0) !=
                  //                                               0
                  //                                           ? TextDecoration
                  //                                               .lineThrough
                  //                                           : TextDecoration
                  //                                               .none),
                  //                             ),
                  //                             (cart?.discount ?? 0) != 0
                  //                                 ? Container(
                  //                                     margin: EdgeInsets.only(
                  //                                         top: 8.r),
                  //                                     decoration: BoxDecoration(
                  //                                         color: AppColors.red,
                  //                                         borderRadius:
                  //                                             BorderRadius
                  //                                                 .circular(
                  //                                                     30.r)),
                  //                                     padding:
                  //                                         EdgeInsets.all(4.r),
                  //                                     child: Row(
                  //                                       children: [
                  //                                         SvgPicture.asset(
                  //                                             "assets/svg/discount.svg"),
                  //                                         4.horizontalSpace,
                  //                                         Text(
                  //                                           intl.NumberFormat
                  //                                               .currency(
                  //                                             symbol: symbol ??
                  //                                                 LocalStorage
                  //                                                         .getSelectedCurrency()
                  //                                                     .type,
                  //                                           ).format(sumPrice),
                  //                                           style: GoogleFonts.inter(
                  //                                               fontWeight:
                  //                                                   FontWeight
                  //                                                       .w600,
                  //                                               fontSize: 14.sp,
                  //                                               color: AppColors
                  //                                                   .white),
                  //                                         )
                  //                                       ],
                  //                                     ),
                  //                                   )
                  //                                 : const SizedBox.shrink()
                  //                           ],
                  //                         )
                  //                       : const SizedBox.shrink(),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         4.horizontalSpace,
                  //         Stack(
                  //           children: [
                  //             CommonImage(
                  //                 imageUrl: cart?.stock?.product?.img ?? "",
                  //                 // : cartTwo?.stock?.product?.img ?? "",
                  //                 width: 100,
                  //                 height: 100,
                  //                 radius: 10.r),
                  //             (cart?.stock?.bonus != null)
                  //                 ? Positioned(
                  //                     bottom: 4.r,
                  //                     right: 4.r,
                  //                     child: Container(
                  //                       width: 22.w,
                  //                       height: 22.h,
                  //                       decoration: const BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           color: AppColors.blue),
                  //                       child: Icon(
                  //                         FlutterRemix.gift_2_fill,
                  //                         size: 16.r,
                  //                         color: AppColors.white,
                  //                       ),
                  //                     ),
                  //                   )
                  //                 : const SizedBox.shrink(),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                ),
          isActive ? const Divider() : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
