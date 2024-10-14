// ignore_for_file: depend_on_referenced_packages

import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/core/utils/local_storage.dart';
import 'package:garista_pos/src/core/utils/time_service.dart';
import 'package:garista_pos/src/models/data/addons_data.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:garista_pos/src/presentation/components/components.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/order_detail/print_page.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GenerateCheckPage extends StatefulWidget {
  final OrderData? orderData;

  const GenerateCheckPage({super.key, required this.orderData});

  @override
  State<GenerateCheckPage> createState() => _GenerateCheckPageState();
}

class _GenerateCheckPageState extends State<GenerateCheckPage> {

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
    num subTotal = 0;
    subTotal = safeConvertToNum(widget.orderData?.total);
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10.r)),
      padding: EdgeInsets.all(16.r),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppHelpers.getTranslation(TrKeys.orderSummary),
              style: GoogleFonts.inter(
                  fontSize: 22.sp, fontWeight: FontWeight.w600),
            ),
            8.verticalSpace,
            Text(
              "${AppHelpers.getTranslation(TrKeys.order)} #${AppHelpers.getTranslation(TrKeys.id)}${widget.orderData?.id}",
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            12.verticalSpace,
            Row(
              children: List.generate(
                  20,
                  (index) => Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.r),
                            height: 2,
                            color: AppColors.iconButtonBack),
                      )),
            ),
            12.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.shopName),
                    style: GoogleFonts.inter(
                        fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  widget.orderData?.status ?? "",
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.client),
                    style: GoogleFonts.inter(
                        fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  "${LocalStorage.getUser()?.firstName ?? ""} ${LocalStorage.getUser()?.lastName ?? ""}",
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            8.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text(
                    AppHelpers.getTranslation(TrKeys.date),
                    style: GoogleFonts.inter(
                        fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  TimeService.dateFormatYMDHm(widget.orderData?.createdAt),
                  style: GoogleFonts.inter(
                      fontSize: 12.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            10.verticalSpace,
            Divider(
              thickness: 2.r,
            ),
            ListView.builder(
                padding: EdgeInsets.only(top: 16.r),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.orderData?.dishes?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.r),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.orderData?.dishes?[index].name ?? ""} x ${widget.orderData?.dishes?[index].quantity ?? ""}",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: AppColors.black),
                                  ),
                                  6.verticalSpace,
                                  // for (Addons e in (widget
                                  //         .orderData?.dishes?[index].addons ??
                                  //     []))
                                  //   Text(
                                  //     "${e.stocks?.product?.translation?.title ?? ""} ( ${NumberFormat.currency(
                                  //       symbol: widget
                                  //               .orderData?.currency?.symbol ??
                                  //           "",
                                  //     ).format((e.price ?? 0) / (e.quantity ?? 1))} x ${(e.quantity ?? 1)} )",
                                  //     style: GoogleFonts.inter(
                                  //       fontSize: 14.sp,
                                  //       color: AppColors.unselectedTab,
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                            Text("${(widget.orderData?.dishes?[index].quantity ?? 1) * safeConvertToNum(widget.orderData?.dishes?[index].price)} ${LocalStorage.getBrand()?.currency}",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  color: AppColors.black),
                            )
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          children: List.generate(
                              20,
                              (index) => Expanded(
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.r),
                                        height: 2,
                                        color: AppColors.iconButtonBack),
                                  )),
                        )
                      ],
                    ),
                  );
                }),
            Row(
              children: List.generate(
                  20,
                  (index) => Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.r),
                            height: 2,
                            color: AppColors.iconButtonBack),
                      )),
            ),
            20.verticalSpace,
            Row(
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.subtotal),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  NumberFormat.currency(
                    symbol: LocalStorage.getBrand()?.currency,
                  ).format(subTotal),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.tax),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
              ],
            ),
           
            10.verticalSpace,
            Row(
              children: [
                Text(
                  AppHelpers.getTranslation(TrKeys.totalPrice),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text("${widget.orderData?.total ?? 1} ${LocalStorage.getBrand()?.currency}",
                  style: GoogleFonts.inter(
                      fontSize: 14.sp, fontWeight: FontWeight.w400),
                )
              ],
            ),
            10.verticalSpace,
            Row(
              children: List.generate(
                  20,
                  (index) => Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.r),
                            height: 2,
                            color: AppColors.iconButtonBack),
                      )),
            ),
            26.verticalSpace,
            Text(
              AppHelpers.getTranslation(TrKeys.thankYou).toUpperCase(),
              style: GoogleFonts.inter(
                  fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            24.verticalSpace,
            LoginButton(
                title: AppHelpers.getTranslation(TrKeys.print),
                onPressed: () async {
                  if (context.mounted) {
                    AppHelpers.showAlertDialog(
                        context: context,
                        child: PrintPage(orderData: widget.orderData));
                  }
                })
          ],
        ),
      ),
    );
  }
}
