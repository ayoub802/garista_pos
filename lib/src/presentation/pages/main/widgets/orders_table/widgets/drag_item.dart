import 'package:garista_pos/generated/assets.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/utils/app_helpers.dart';
import '../../../../../components/components.dart';
import '../../../../../theme/theme.dart';
import '../../../riverpod/provider/main_provider.dart';
import '../icon_title.dart';
import 'custom_popup_item.dart';

class DragItem extends ConsumerWidget {
  final OrderData orderData;
  final bool isDrag;

  const DragItem({super.key, required this.orderData, this.isDrag = false});

  @override
  Widget build(BuildContext context, ref) {
    return InkWell(
      child: Transform.rotate(
        angle: isDrag ? (3.14 * (0.03)) : 0,
        child: Container(
          foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isDrag ? AppColors.iconColor.withOpacity(0.3) : null),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: AppColors.white),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonImage(
                    imageUrl: LocalStorage.getUser()?.image,
                    height: 42,
                    width: 42,
                    radius: 32,
                    isResponsive: false,
                  ),
                  6.horizontalSpace,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocalStorage.getUser()?.firstName ?? "",
                            maxLines: 1,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "#${orderData.id}",
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.hintColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // CustomPopup(
                  //   orderData: orderData,
                  //   isLocation: orderData.deliveryType == TrKeys.delivery,
                  // ),
                ],
              ),
              6.verticalSpace,
              const Divider(height: 2),
              12.verticalSpace,
              IconTitle(
                title: AppHelpers.getTranslation(TrKeys.date),
                icon: FlutterRemix.calendar_2_line,
                value: DateFormat("MMMM dd HH:mm")
                    .format(orderData.createdAt?.toLocal() ?? DateTime.now()),
              ),
              IconTitle(
                title: "Total",
                icon: FlutterRemix.money_dollar_circle_line,
                value: orderData?.total?.toString(),
              ),
              // IconTitle(
              //   title: AppHelpers.getTranslation(TrKeys.paymentType),
              //   icon: FlutterRemix.money_euro_circle_line,
              //   value: orderData.transaction?.paymentSystem?.tag ?? "- -",
              // ),

              IconTitle(
                title: "Table",
                icon: FlutterRemix.money_dollar_circle_line,
                value: orderData.table?.name ??
                    "- -", // Safely access the table name
              ),
              12.verticalSpace,
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            "Deivery",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(4),
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.black),
                            shape: BoxShape.circle),
                        child: Icon(
                          FlutterRemix.e_bike_2_fill,
                          size: 16,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
      onTap: () {
        ref.read(mainProvider.notifier).setOrder(orderData);
      },
    );
  }
}
