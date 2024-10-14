import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/time_service.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:garista_pos/src/presentation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../components/components.dart';

class DocumentScreen extends StatelessWidget {
  final OrderData? orderData;

  const DocumentScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedBorderTextField(
                  readOnly: true,
                  label: null,
                  textController: TextEditingController(
                      text:
                          "${LocalStorage.getUser()?.firstName ?? ""} ${LocalStorage.getUser()?.lastName ?? ""}"),
                  suffixIcon: const Icon(FlutterRemix.arrow_down_s_line),
                ),
              ),
              42.horizontalSpace,
              Expanded(
                child: OutlinedBorderTextField(
                  readOnly: true,
                  textController: TextEditingController(
                      text: orderData?.table?.name ?? ""),
                  label: null,
                  suffixIcon: const Icon(FlutterRemix.arrow_down_s_line),
                ),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedBorderTextField(
                  readOnly: true,
                  textController: TextEditingController(
                      text:
                          "${LocalStorage.getBrand()?.currency ?? ""}"),
                  label: null,
                  suffixIcon: const Icon(FlutterRemix.arrow_down_s_line),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          const Divider(),
          8.verticalSpace,
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: OutlinedBorderTextField(
                  readOnly: true,
                  textController: TextEditingController(
                    text: TimeService.dateFormatYMDHm(orderData?.createdAt),
                  ),
                  label: null,
                  suffixIcon: const Icon(FlutterRemix.arrow_down_s_line),
                ),
              ),
              42.horizontalSpace,
              Expanded(
                child: OutlinedBorderTextField(
                  readOnly: true,
                  textController: TextEditingController(
                      text: TimeService.dateFormatYMDHm(orderData?.createdAt) ?? ""),
                  label: null,
                  suffixIcon: const Icon(FlutterRemix.arrow_down_s_line),
                ),
              ),
            ],
          ),
          16.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.note),
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, fontSize: 18.r),
                ),
                Text(
                  orderData?.status ?? '',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.r,
                      color: AppColors.reviewText),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Row _paymentType() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: orderData?.deliveryType == TrKeys.delivery
  //                 ? AppColors.brandColor
  //                 : AppColors.editProfileCircle,
  //             borderRadius: BorderRadius.circular(6.r),
  //           ),
  //           padding: EdgeInsets.symmetric(vertical: 10.r),
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: AppColors.transparent,
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: AppColors.black),
  //                   ),
  //                   padding: EdgeInsets.all(6.r),
  //                   child: Icon(
  //                     FlutterRemix.takeaway_fill,
  //                     size: 18.sp,
  //                   ),
  //                 ),
  //                 8.horizontalSpace,
  //                 Text(
  //                   AppHelpers.getTranslation(TrKeys.delivery),
  //                   style: GoogleFonts.inter(
  //                       fontSize: 14.sp, fontWeight: FontWeight.w600),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       12.horizontalSpace,
  //       Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: orderData?.deliveryType == TrKeys.pickup
  //                 ? AppColors.brandColor
  //                 : AppColors.editProfileCircle,
  //             borderRadius: BorderRadius.circular(6.r),
  //           ),
  //           padding: EdgeInsets.symmetric(vertical: 10.r),
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: AppColors.transparent,
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: AppColors.black),
  //                   ),
  //                   padding: EdgeInsets.all(6.r),
  //                   child: SvgPicture.asset("assets/svg/pickup.svg"),
  //                 ),
  //                 8.horizontalSpace,
  //                 Text(
  //                   AppHelpers.getTranslation(TrKeys.takeAway),
  //                   style: GoogleFonts.inter(
  //                       fontSize: 14.sp, fontWeight: FontWeight.w600),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //       12.horizontalSpace,
  //       Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: orderData?.deliveryType == TrKeys.dine
  //                 ? AppColors.brandColor
  //                 : AppColors.editProfileCircle,
  //             borderRadius: BorderRadius.circular(6.r),
  //           ),
  //           padding: EdgeInsets.symmetric(vertical: 10.r),
  //           child: Center(
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     color: AppColors.transparent,
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: AppColors.black),
  //                   ),
  //                   padding: EdgeInsets.all(6.r),
  //                   child: SvgPicture.asset("assets/svg/dine.svg"),
  //                 ),
  //                 8.horizontalSpace,
  //                 Text(
  //                   AppHelpers.getTranslation(TrKeys.dine),
  //                   style: GoogleFonts.inter(
  //                       fontSize: 14.sp, fontWeight: FontWeight.w600),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }
}
