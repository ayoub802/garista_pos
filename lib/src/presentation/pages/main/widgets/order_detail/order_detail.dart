// ignore_for_file: unrelated_type_equality_checks

import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:garista_pos/src/models/data/order_detail_data.dart';
// import 'package:garista_pos/src/presentation/components/buttons/invoice_download.dart';
// import 'package:garista_pos/src/presentation/pages/main/widgets/order_detail/widgets/document.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/order_detail/widgets/products.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/order_detail/widgets/status_screen.dart';
// import 'package:garista_pos/src/presentation/pages/main/widgets/order_detail/widgets/user_information.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/utils/local_storage.dart';
import '../../../../components/components.dart';
import '../../riverpod/provider/main_provider.dart';
// import 'generate_check.dart';

class OrderDetailPage extends ConsumerStatefulWidget {
  final OrderData order;

  const OrderDetailPage({super.key, required this.order});

  @override
  ConsumerState<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends ConsumerState<OrderDetailPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.refresh(orderDetailsProvider.notifier)
        ..fetchOrderDetails(order: widget.order)
        ..fetchUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('The order Detail => ');
    // final state = ref.watch(orderDetailsProvider);
    num subTotal = 0;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainBack,
        body: ListView(
          padding: EdgeInsets.all(16.r),
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => ref.read(mainProvider.notifier).setOrder(null),
                  child: Row(
                    children: [
                      Icon(
                        FlutterRemix.arrow_left_s_line,
                        size: 32.r,
                      ),
                      Text(
                        AppHelpers.getTranslation(TrKeys.back),
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // InvoiceDownload(orderData: state.order),
                16.horizontalSpace,
                ConfirmButton(
                  textColor: AppColors.black,
                  title: AppHelpers.getTranslation(TrKeys.statusChanged),
                  onTap: () {},
                  height: 52.r,
                )
              ],
            ),
            16.verticalSpace,
            StatusScreen(
              orderDataStatus: "New",
            ),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // DocumentScreen(orderData: state.order),
                      24.verticalSpace,
                      ProductsScreen(
                        // orderData: ,
                        subTotal: subTotal,
                        onEdit: (id, status) {
                          // ref
                          //     .read(orderDetailsProvider.notifier)
                          //     .changeDetailStatus(status);
                          // showDialog(
                          //     context: context,
                          //     builder: (context) {
                          //       return _changeDetailStatusDialog(
                          //           status, id, context);
                          //     });
                        },
                      )
                    ],
                  ),
                ),
                16.horizontalSpace,
                // Expanded(
                //   flex: 2,
                //   child: UserInformation(
                //     user: state.order?.user,
                //     order: state.order,
                //     selectUser: state.selectedUser,
                //     onChanged: (v) => ref
                //         .read(orderDetailsProvider.notifier)
                //         .setUsersQuery(context, v),
                //     setDeliveryman: () => ref
                //         .read(orderDetailsProvider.notifier)
                //         .setDeliveryMan(context),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AlertDialog _changeDetailStatusDialog(
      String status, int? id, BuildContext context) {
    return AlertDialog(
      content: PopupMenuButton<String>(
        itemBuilder: (context) {
          return [
            PopupMenuItem<String>(
              value: status,
              child: Text(
                AppHelpers.getTranslation(status),
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            PopupMenuItem<String>(
              value: AppHelpers.getNextOrderStatus(status),
              child: Text(
                AppHelpers.getTranslation(
                    AppHelpers.getNextOrderStatus(status)),
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            PopupMenuItem<String>(
              value: TrKeys.canceled,
              child: Text(
                AppHelpers.getTranslation(TrKeys.cancel),
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            )
          ];
        },
        onSelected: (s) {
          // ref.read(orderDetailsProvider.notifier).changeDetailStatus(s);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        color: AppColors.white,
        elevation: 10,
        child: Consumer(builder: (context, ref, child) {
          return SelectFromButton(
            title: "Detail",
          );
        }),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.r),
          child: SizedBox(
            width: 150.w,
            child: ConfirmButton(
                title: AppHelpers.getTranslation(TrKeys.save),
                onTap: () {
                  // ref.watch(orderDetailsProvider).detailStatus == status
                  //     ? null
                  //     : ref
                  //         .read(orderDetailsProvider.notifier)
                  //         .updateOrderDetailStatus(
                  //             status:
                  //                 ref.watch(orderDetailsProvider).detailStatus,
                  //             id: id,
                  //             success: () {
                  //               Navigator.pop(context);
                  //             });
                }),
          ),
        ),
      ],
    );
  }

  AlertDialog _changeStatusDialog(BuildContext context) {
    return AlertDialog(
      content: PopupMenuButton<String>(
        itemBuilder: (context) {
          return [
            PopupMenuItem<String>(
              value: "New",
              child: Text(
                "Status",
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            PopupMenuItem<String>(
              value: "Status",
              child: Text(
                "Status",
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
            PopupMenuItem<String>(
              value: AppHelpers.getTranslation(TrKeys.cancel),
              child: Text(
                AppHelpers.getTranslation(TrKeys.cancel),
                style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500),
              ),
            )
          ];
        },
        onSelected: (s) {
          // ref.read(orderDetailsProvider.notifier).changeStatus(s);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        color: AppColors.white,
        elevation: 10,
        child: Consumer(builder: (context, ref, child) {
          return SelectFromButton(
            title: "Status",
          );
        }),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.r),
          child: SizedBox(
            width: 150.w,
            child: ConfirmButton(
                title: AppHelpers.getTranslation(TrKeys.save),
                onTap: () {
                  // ref.watch(orderDetailsProvider).status.isEmpty
                  //     ? null
                  //     : ref
                  //         .read(orderDetailsProvider.notifier)
                  //         .updateOrderStatus(
                  //             status: AppHelpers.getOrderStatus(
                  //               ref.watch(orderDetailsProvider).status,
                  //             ),
                  //             success: () {
                  //               Navigator.pop(context);
                  //               if (AppHelpers.getAutoPrint() &&
                  //                   AppHelpers.getOrderStatus(ref
                  //                           .watch(orderDetailsProvider)
                  //                           .status) ==
                  //                       OrderStatus.accepted) {
                  //                 showDialog(
                  //                     context: context,
                  //                     builder: (context) {
                  //                       return LayoutBuilder(
                  //                           builder: (context, constraints) {
                  //                         return SimpleDialog(
                  //                           title: SizedBox(
                  //                             height:
                  //                                 constraints.maxHeight * 0.7,
                  //                             width: 300.r,
                  //                             child: GenerateCheckPage(
                  //                                 orderData: state.order),
                  //                           ),
                  //                         );
                  //                       });
                  //                     });
                  //               }
                  //             });
                }),
          ),
        ),
      ],
    );
  }
}
