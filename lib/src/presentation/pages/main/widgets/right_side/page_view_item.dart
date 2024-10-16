import 'package:garista_pos/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:garista_pos/src/presentation/components/list_items/product_bag_item.dart';
// import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/note_dialog.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/order_information.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/riverpod/state/right_side_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/riverpod/tables_provider.dart';
import 'package:garista_pos/generated/assets.dart';
import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/models.dart';
import '../../../../components/components.dart';
import '../../../../theme/theme.dart';
import 'promo_code_dialog.dart';
import 'riverpod/provider/right_side_provider.dart';

class PageViewItem extends ConsumerStatefulWidget {
  final BagData bag;

  const PageViewItem({super.key, required this.bag});

  @override
  ConsumerState<PageViewItem> createState() => _PageViewItemState();
}

class _PageViewItemState extends ConsumerState<PageViewItem> {
  late TextEditingController coupon;
  String? selectedTable;

  @override
  void initState() {
    super.initState();
    coupon = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tablesProvider.notifier).initial();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(rightSideProvider.notifier)
          .setInitialBagData(context, widget.bag);
    });
  }

  @override
  void dispose() {
    coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(rightSideProvider.notifier);
    final state = ref.watch(rightSideProvider);
    final currency = LocalStorage.getBrand();

    // print("The Bags State => ${state.bags[0]!.bagProducts![0]!.carts}");
    return AbsorbPointer(
      absorbing: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.white,
                  ),
                  child: (state.isProductCalculateLoading ?? false)
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 8.r,
                                right: 24.r,
                                left: 24.r,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppHelpers.getTranslation(TrKeys.products),
                                    style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      notifier.clearBag(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(8.r),
                                      child: const Icon(
                                        FlutterRemix.delete_bin_line,
                                        color: AppColors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              // Update itemCount to sum all products in all BagProductData entries
                              itemCount: state
                                  .bags[state.selectedBagIndex]?.bagProducts
                                  ?.fold<int>(
                                      0,
                                      (previousValue, bagProduct) =>
                                          previousValue +
                                          (bagProduct.carts?.length ?? 0)),
                              itemBuilder: (context, index) {
                                // Flatten all carts from all bagProducts
                                final List<CartProductData> allCarts = [];
                                for (var bagProduct in state
                                        .bags[state.selectedBagIndex]
                                        .bagProducts ??
                                    []) {
                                  allCarts.addAll(bagProduct.carts ?? []);
                                }

                                // Ensure we don't exceed the length of allCarts
                                if (index >= allCarts.length) return SizedBox();

                                // Retrieve the correct cart item
                                final cartItem = allCarts[index];

                                return CartOrderItem(
                                  symbol: currency?.currency,
                                  add: () {
                                    // Your logic to increase product count
                                    notifier.increaseProductCount(
                                        context: context, productIndex: index);
                                  },
                                  remove: () {
                                    notifier.decreaseProductCount(
                                        context: context, productIndex: index);
                                  },
                                  cart: [
                                    cartItem
                                  ], // Pass the correct cart item to the widget
                                  delete: () {
                                    // Logic to delete the product from the cart
                                    notifier.deleteProductCount(
                                      context: context,
                                      productIndex: index,
                                    );
                                  },
                                );
                              },
                            ),
                            8.verticalSpace,
                            Column(
                              children: [
                                _price(state, currency?.currency, notifier, selectedTable),
                              ],
                            ),
                            28.verticalSpace,
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            170.verticalSpace,
                            Container(
                              width: 142.r,
                              height: 142.r,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.dontHaveAccBtnBack,
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                Assets.pngNoProducts,
                                width: 87.r,
                                height: 60.r,
                                fit: BoxFit.cover,
                              ),
                            ),
                            14.verticalSpace,
                            Text(
                              '${AppHelpers.getTranslation(TrKeys.thereAreNoItemsInThe)} ${AppHelpers.getTranslation(TrKeys.bag).toLowerCase()}',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -14 * 0.02,
                                color: AppColors.black,
                              ),
                            ),
                            SizedBox(height: 170.r, width: double.infinity),
                          ],
                        ),
                ),
                15.verticalSpace,
              ],
            ),
          ),
          // BlurLoadingWidget(
          //     isLoading: state.isBagsLoading || state.isCurrenciesLoading),
        ],
      ),
    );
  }

  Column _price(RightSideState state, String? currency, rightSideNotifier, String? selectedTable) {
    num totalPrice = AppHelpers.calculateTotalPrice(state);

    String formattedPrice = NumberFormat.currency(
      symbol: '', // Set an empty symbol to handle the currency separately
      decimalDigits: 2, // Ensure two decimal places
    ).format(totalPrice);
    return Column(
      children: [
        8.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.totalPrice),
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    '$formattedPrice',
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              LoginButton(
                title: AppHelpers.getTranslation(TrKeys.order),
                titleColor: AppColors.white,
                onPressed: () async {
                  final List<CartProductData> allCarts = [];
                  for (var bagProduct
                      in state.bags[state.selectedBagIndex].bagProducts ?? []) {
                    allCarts.addAll(bagProduct.carts ?? []);
                  }
                  final cartItems = allCarts.map((item) {
                    // Extract and format selected toppings
                    final List<Map<String, dynamic>> formattedToppings =
                        item.selectedToppings?.map((topping) {
                              return {
                                'name': topping.name,
                                'id': topping.id,
                                'option': topping.options
                                    ?.map((option) => {
                                          'name': option.name,
                                          'price': option.price,
                                        })
                                    .toList(),
                              };
                            }).toList() ??
                            [];
                    final List<Map<String, dynamic>> formattedVariants =
                        item.selectedVariants?.map((variant) {
                              return {
                                'name': variant.name,
                                'id': variant.id,
                                'option': variant.options
                                    ?.map((option) => {
                                          'name': option.name,
                                          'price': option.price,
                                        })
                                    .toList(),
                              };
                            }).toList() ??
                            [];
                    final List<Map<String, dynamic>> formattedIngredients =
                        item.selectedIngrediants?.map((variant) {
                              return {
                                'name': variant.name,
                              };
                            }).toList() ??
                            [];

                    // Print out the formatted toppings
                    print(
                        'Toppings for product ID: ${item.productId} - $formattedVariants');

                    return CartItem(
                        type: item.type,
                        id: item.productId,
                        quantity: item.quantity,
                        comment: '',
                        toppings: formattedToppings,
                        ingredients: formattedIngredients,
                        extraVariants: formattedVariants);
                  }).toList();
                  int restoId = LocalStorage.getRestaurant()?.id ?? 0;
                 
                  for (var cartItem in cartItems) {
                    print(
                        'Type: ${cartItem.type}, ID: ${cartItem.id}, Quantity: ${cartItem.quantity}, Comment: ${cartItem.comment}, topping: ${cartItem.toppings}');
                  }
                  
 
                 AppHelpers.showAlertDialog(
                      context: context, 
                      child: OrderInformation(
                        selectedTable: selectedTable,
                        orderfunction: () async {
                          //   rightSideNotifier.createOrder(
                          //   context,
                          //   cartItems,
                          //   totalPrice,
                          //   int.tryParse(selectedTable.toString()) ?? 0, // Convert selectedTable to an int
                          //   restoId,
                          //   onSuccess: () {
                          //     // Optional success action
                          //     print("Order created successfully!");
                          //   },
                          // );
                          print("The Selected Tbales $selectedTable");
                        },
                      )
                 );
                }
              )
            ],
          ),
        ),
      ],
    );
  }

  // @override
  // Widget OrderModal(BuildContext context, Function()? orderfunction, RightSideState state, String? selectedTable, ValueChanged<String?> onTableSelected,) {
  //  final stateTable = ref.watch(tablesProvider);

  //  List<DropdownMenuItem<String>> dropdownItems = stateTable.tableListData
  //       .map((table) {
  //     return DropdownMenuItem<String>(
  //       value: table?.id.toString(), // Assuming each table has an 'id'
  //       child: Text(table?.name ?? 'Unknown Table'), // Handle potential null 'name'
  //     );
  //   }).toList();

  //   print("The Selected Tables => $selectedTable");


  //   return KeyboardDismisser(
  //     child: Container(
  //       width: 350.w,
  //       padding: REdgeInsets.symmetric(horizontal: 24.r),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.r),
  //         color: AppColors.white,
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   AppHelpers.getTranslation(TrKeys.order),
  //                   style: GoogleFonts.inter(
  //                       fontSize: 22.r, fontWeight: FontWeight.w600),
  //                 ),
  //                 const Spacer(),
  //                 IconButton(
  //                   onPressed: () {
  //                     // context.popRoute();
  //                   },
  //                   icon: const Icon(FlutterRemix.close_line),
  //                 ),
  //               ],
  //             ),
  //             16.verticalSpace,
  //              Padding(
  //                 padding: REdgeInsets.all(16),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                         flex: !stateTable.isListView ? 15 : 15,
  //                         child: Padding(
  //                             padding: REdgeInsets.only(left: 16, right: 17),
  //                             child: Column(
  //                               mainAxisSize: MainAxisSize.max,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Row(
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Text(
  //                                       "Select The Table :",
  //                                       style: GoogleFonts.inter(
  //                                         fontSize: 22.sp,
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 24.verticalSpace,
  //                             Stack(
  //                                   children: [
  //                                     SizedBox(
  //                                     height: 250.h,
  //                                     width: 350.w,
  //                                       child: Column(
  //                                     children: [
  //                                        DropdownButton<String>(
  //                                         isExpanded: true,
  //                                         value: selectedTable, // Current selected table
  //                                         hint: Text("Selecte a Table"),
  //                                         items: dropdownItems, // The dropdown menu items
  //                                         onChanged: (String? newValue) {
  //                                           setState(() {
  //                                             onTableSelected(newValue); // Update selected table
  //                                           });
  //                                           // Additional logic to handle table selection can be added here
  //                                         },
  //                                       ),
  //                                     ]
  //                                       )
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ))),
  //                   ],
  //                 ),
  //               ),
  //             LoginButton(
  //               isLoading: state.isOrderLoading,
  //               title: AppHelpers.getTranslation(TrKeys.order),
  //               titleColor: AppColors.white,
  //               onPressed: orderfunction
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

}
