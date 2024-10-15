import 'package:garista_pos/generated/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/add_product/add_product_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/add_product/provider/add_product_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/utils.dart';
import '../../../components/components.dart';
import '../../../theme/theme.dart';
import '../riverpod/provider/main_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/riverpod/provider/right_side_provider.dart';

class ProductsList extends ConsumerWidget {
  const ProductsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mainProvider);
    final notifier = ref.read(mainProvider.notifier);
    final notifierAdd = ref.read(addProductProvider.notifier);
    final rightSideState = ref.watch(rightSideProvider);
    final rightSideNotifier = ref.read(rightSideProvider.notifier);
  late double totalPrice;

    return state.isProductsLoading
        ? const ProductGridListShimmer()
        : state.products.isNotEmpty
            ? ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                }),
                child: ListView(
                  shrinkWrap: false,
                  cacheExtent: (state.products.length / 4) * 250,
                  children: [
                    AnimationLimiter(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: state.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 200 / 300,
                          mainAxisSpacing: 10.r,
                          crossAxisSpacing: 10.r,
                          crossAxisCount: 4,
                        ),
                        padding: REdgeInsets.only(top: 8, bottom: 10),
                        itemBuilder: (context, index) {
                          final product = state.products[index];
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: state.products.length,
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: ScaleAnimation(
                              scale: 0.5,
                              child: FadeInAnimation(
                                child: ProductGridItem(
                                  product: product,
                                  onTap: () {
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return AddProductDialog(
                                    //         product: product);
                                    //   },
                                    // );
                                    bool hasRequiredToppings = product.toppings != null && product.toppings!.any((topping) => topping.required == true);
                                    if (hasRequiredToppings) {
                                      // Open the dialog if any topping has required set to true
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddProductDialog(product: product);
                                        },
                                      );
                                    } 
                                    else{
                                       notifierAdd.addProductToBag(
                                          context,
                                          rightSideState.selectedBagIndex,
                                          rightSideNotifier,
                                          1,
                                          totalPrice = double.tryParse(product?.price ?? '0.0') ?? 0.0,
                                          product,
                                          [],
                                          [],
                                          [],
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    10.verticalSpace,
                    state.isMoreProductsLoading
                        ? const ProductGridListShimmer(verticalPadding: 0)
                        : (state.hasMore
                            ? Material(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.r),
                                  onTap: () {
                                    notifier.fetchProducts(
                                      checkYourNetwork: () {
                                        AppHelpers.showSnackBar(
                                          context,
                                          AppHelpers.getTranslation(TrKeys
                                              .checkYourNetworkConnection),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 50.r,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color:
                                            AppColors.black.withOpacity(0.17),
                                        width: 1.r,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppHelpers.getTranslation(
                                          TrKeys.viewMore),
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()),
                    15.verticalSpace,
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(left: 64.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    170.verticalSpace,
                    Container(
                      width: 142.r,
                      height: 142.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: AppColors.white,
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
                      '${AppHelpers.getTranslation(TrKeys.thereAreNoItemsInThe)} ${AppHelpers.getTranslation(TrKeys.products).toLowerCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -14 * 0.02,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              );
  }
}
