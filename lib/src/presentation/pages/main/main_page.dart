// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:auto_route/auto_route.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garista_pos/src/presentation/pages/auth/login/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../generated/assets.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/utils.dart';
import '../../components/components.dart';
import '../../theme/theme.dart';
import 'package:garista_pos/src/presentation/components/custom_scaffold.dart';
import 'package:garista_pos/src/presentation/theme/theme/theme_warpper.dart';
import 'package:garista_pos/src/presentation/components/custom_clock/custom_clock.dart';
import 'riverpod/provider/main_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/riverpod/state/main_state.dart';
import 'package:garista_pos/src/presentation/pages/main/riverpod/notifier/main_notifier.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';
import 'widgets/right_side/riverpod/provider/right_side_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/post_page.dart';
import 'widgets/profile/edit_profile/edit_profile_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  // final user = LocalStorage.getUser();
  Timer? timer;
  late List<IndexedStackChild> list = [
    IndexedStackChild(child: const PostPage(), preload: true),
    IndexedStackChild(child: const ProfilePage()),
    IndexedStackChild(child: const TablesPage()),
    // IndexedStackChild(child: const OrdersTablesPage()),
    // IndexedStackChild(child: const CustomersPage()),
    // IndexedStackChild(child: const SaleHistory()),
    // IndexedStackChild(child: const InComePage()),
  ];
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainProvider.notifier)
        ..fetchProducts(
          checkYourNetwork: () {
            AppHelpers.showSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
            );
          },
        )
        ..fetchCategories(
          context: context,
          checkYourNetwork: () {
            AppHelpers.showSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
            );
          },
        )
        ..fetchBrands(
          checkYourNetwork: () {
            AppHelpers.showSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
            );
          },
        )
        ..fetchUserDetail(context)
        ..changeIndex(0);
      ref.read(rightSideProvider.notifier).fetchUsers(
        checkYourNetwork: () {
          AppHelpers.showSnackBar(
            context,
            AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
          );
        },
      );
      // } else if (user?.role == TrKeys.cooker) {
      //   ref.read(mainProvider.notifier)
      //     ..fetchUserDetail(context)
      //     ..changeIndex(0);
      // } else {
      //   ref.read(mainProvider.notifier)
      //     ..fetchProducts(
      //       checkYourNetwork: () {
      //         AppHelpers.showSnackBar(
      //           context,
      //           AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
      //         );
      //       },
      //     )
      //     ..fetchCategories(
      //       context: context,
      //       checkYourNetwork: () {
      //         AppHelpers.showSnackBar(
      //           context,
      //           AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
      //         );
      //       },
      //     )
      //     ..fetchUserDetail(context)
      //     ..changeIndex(0);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainProvider);
    // final customerNotifier = ref.read(customerProvider.notifier);
    final notifier = ref.read(mainProvider.notifier);
    return SafeArea(
      child: CustomScaffold(
        extendBody: true,
        appBar: (colors) => customAppBar(),
        backgroundColor: AppColors.mainBack,
        body: (c) => Directionality(
          textDirection: TextDirection.ltr,
          child: KeyboardDismisser(
              child: Row(
            children: [
              bottomLeftNavigationBar(state),
              Expanded(
                child: ProsteIndexedStack(
                  index: state.selectIndex,
                  children: list,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  AppBar customAppBar() {
    // print("The Info Brand => ${ref.watch(mainProvider).brands[0].description}");
    final state = ref.watch(mainProvider);
    final brand = LocalStorage.getBrand();
    print("The Bran is => ${brand!.description}");
    return AppBar(
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      elevation: 0.5,
      title: IntrinsicHeight(
        child: ThemeWrapper(builder: (colors, controller) {
          return Row(
            children: [
              16.horizontalSpace,
              // SvgPicture.asset(Assets.svgLogo),
              CircleImage(
                imageUrl: brand!.logo,
              ),
              12.horizontalSpace,
              Text(
                AppHelpers.getRestaurnatName() ?? "Garista",
                style: GoogleFonts.inter(
                    color: AppColors.black, fontWeight: FontWeight.bold),
              ),
              const VerticalDivider(),
              30.horizontalSpace,
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      FlutterRemix.search_2_line,
                      size: 20.r,
                      color: AppColors.black,
                    ),
                    17.horizontalSpace,
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        onChanged: (value) {
                          // if (user?.role == TrKeys.seller) {
                          //   ref.watch(mainProvider).selectIndex == 2
                          //       ? customerNotifier.searchUsers(
                          //           context, value.trim())
                          //       : notifier.setProductsQuery(
                          //           context, value.trim());
                          //   if (ref.watch(mainProvider).selectIndex == 1) {
                          //     ref
                          //         .read(newOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(acceptedOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(readyOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(onAWayOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(deliveredOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(canceledOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //   }
                          // } else if (user?.role == TrKeys.cooker) {
                          //   ref
                          //       .read(kitchenProvider.notifier)
                          //       .setOrdersQuery(context, value.trim());
                          // } else {
                          //   if (ref.watch(mainProvider).selectIndex == 1) {
                          //     ref
                          //         .read(newOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(acceptedOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(readyOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(onAWayOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(deliveredOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //     ref
                          //         .read(canceledOrdersProvider.notifier)
                          //         .setOrdersQuery(context, value.trim());
                          //   }
                          //   notifier.setProductsQuery(context, value.trim());
                          // }
                        },
                        cursorColor: AppColors.black,
                        cursorWidth: 1.r,
                        decoration: InputDecoration.collapsed(
                          hintText: "Search",
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: AppColors.searchHint.withOpacity(0.3),
                            letterSpacing: -14 * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VerticalDivider(),
              SizedBox(width: 120.w, child: const CustomClock()),
              const VerticalDivider(),
              IconButton(
                  onPressed: () async {
                    // context.pushRoute(const HelpRoute());
                  },
                  icon: const Icon(
                    FlutterRemix.question_line,
                    color: AppColors.black,
                  )),
              IconButton(
                  onPressed: () {
                    // showDialog(
                    //     context: context,
                    //     builder: (_) => const Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             Dialog(child: NotificationDialog()),
                    //           ],
                    //         ));
                  },
                  icon: const Icon(
                    FlutterRemix.notification_2_line,
                    color: AppColors.black,
                  )),
              // NotificationCountsContainer(
              //     count:
              //         '${ref.watch(notificationProvider).countOfNotifications?.notification ?? 0}'),
              IconButton(
                onPressed: () {
                  // ref.read(languagesProvider.notifier).getLanguages(context);
                  // showDialog(
                  //     context: context,
                  //     builder: (_) => Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             Consumer(builder: (context, ref, child) => Dialog(
                  //               alignment: Alignment.topRight,
                  //               child: Container(
                  //                 width: MediaQuery.sizeOf(context).width / 4,
                  //                 height: 60.0*ref.watch(languagesProvider).languages.length,
                  //                 constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height *0.5),
                  //                 child: Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     Padding(
                  //                       padding: REdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  //                       child: Row(
                  //                         children: [
                  //                           Text(
                  //                             AppHelpers.getTranslation(
                  //                                 TrKeys.language),
                  //                             style: GoogleFonts.inter(
                  //                               fontWeight: FontWeight.w600,
                  //                               fontSize: 22,
                  //                               color: AppColors.black,
                  //                             ),
                  //                           ),
                  //                           const Spacer(),
                  //                           IconButton(
                  //                               onPressed: () {
                  //                                 Navigator.pop(context);
                  //                               },
                  //                               splashRadius: 25,
                  //                               icon: const Icon(
                  //                                   FlutterRemix.close_fill))
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     // Expanded(
                  //                     //   child: LanguagesModal(
                  //                     //     afterUpdate: () {
                  //                     //       controller.toggle();
                  //                     //       controller.toggle();
                  //                     //     },
                  //                     //   ),
                  //                     // ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ),),

                  //           ],
                  //         ));
                },
                icon: const Icon(
                  FlutterRemix.global_line,
                  color: AppColors.black,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Container bottomLeftNavigationBar(MainState state) {

    print('The User ${LocalStorage.getUser()}');
    return Container(
      height: double.infinity,
      width: 90.w,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          24.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color:  state.selectIndex == 0 ? AppColors.GaristaColorBg : AppColors.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(0);
                },
                icon: Icon(
                  state.selectIndex == 0
                  ?
                  FlutterRemix.home_smile_fill
                  :
                  FlutterRemix.home_smile_line,

                  color: state.selectIndex == 0
                  ? AppColors.white
                  : AppColors.iconColor,
                )),
          ),
          28.verticalSpace,
          // Container(
          //   decoration: BoxDecoration(
          //       color: state.selectIndex == 1
          //           ? AppColors.brandColor
          //           : AppColors.transparent,
          //       borderRadius: BorderRadius.circular(10.r)),
          //   child: IconButton(
          //       onPressed: () {
          //         ref.read(mainProvider.notifier).changeIndex(1);
          //       },
          //       icon: Icon(
          //         state.selectIndex == 1
          //             ? FlutterRemix.shopping_bag_fill
          //             : FlutterRemix.shopping_bag_line,
          //         color: state.selectIndex == 1
          //             ? AppColors.white
          //             : AppColors.iconColor,
          //       )),
          // ),
          // 28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 1
                    ? AppColors.GaristaColorBg
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
                onPressed: () {
                  ref.read(mainProvider.notifier).changeIndex(1);
                },
                icon: Icon(
                  state.selectIndex == 2
                      ? FlutterRemix.user_3_fill
                      : FlutterRemix.user_3_line,
                  color: state.selectIndex == 1
                      ? AppColors.white
                      : AppColors.iconColor,
                )),
          ),
          28.verticalSpace,
          Container(
            decoration: BoxDecoration(
                color: state.selectIndex == 2
                    ? AppColors.GaristaColorBg
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(10.r)),
            child: IconButton(
              onPressed: () {
                ref.read(mainProvider.notifier).changeIndex(2);
              },
              icon: SvgPicture.asset(
                state.selectIndex == 2
                    ? Assets.svgSelectTable
                    : Assets.svgTable,
              ),
            ),
          ),
          // 28.verticalSpace,
          // Container(
          //   decoration: BoxDecoration(
          //       color: state.selectIndex == 4
          //           ? AppColors.brandColor
          //           : AppColors.transparent,
          //       borderRadius: BorderRadius.circular(10.r)),
          //   child: IconButton(
          //       onPressed: () {
          //         ref.read(mainProvider.notifier).changeIndex(4);
          //       },
          //       icon: Icon(
          //         state.selectIndex == 4
          //             ? FlutterRemix.money_dollar_circle_fill
          //             : FlutterRemix.money_dollar_circle_line,
          //         color: state.selectIndex == 4
          //             ? AppColors.white
          //             : AppColors.iconColor,
          //       )),
          // ),
          // 28.verticalSpace,
          // Container(
          //   decoration: BoxDecoration(
          //       color: AppColors.brandColor,
          //       borderRadius: BorderRadius.circular(10.r)),
          //   child: IconButton(
          //       onPressed: () {
          //         // ref.read(mainProvider.notifier).changeIndex(5);
          //       },
          //       icon: Icon(
          //         FlutterRemix.pie_chart_fill,
          //             // ? FlutterRemix.pie_chart_fill
          //             // : FlutterRemix.pie_chart_line,
          //         color: AppColors.white,
          //             // ? AppColors.white
          //             // : AppColors.iconColor,
          //       )),
          // ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(mainProvider.notifier).changeIndex(1);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: state.selectIndex == 1
                        ? AppColors.GaristaColorBg
                        : AppColors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(20.r)),
              child: CommonImage(
                  width: 40,
                  height: 40,
                  radius: 20,
                  imageUrl: LocalStorage.getUser()?.image ?? ""),
            ),
          ),
          24.verticalSpace,
          IconButton(
              onPressed: () {
                // context.replaceRoute(const LoginRoute());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage()),
                  );
                // ref.read(newOrdersProvider.notifier).stopTimer();
                // ref.read(acceptedOrdersProvider.notifier).stopTimer();
                // ref.read(cookingOrdersProvider.notifier).stopTimer();
                // ref.read(readyOrdersProvider.notifier).stopTimer();
                // ref.read(onAWayOrdersProvider.notifier).stopTimer();
                // ref.read(deliveredOrdersProvider.notifier).stopTimer();
                // ref.read(canceledOrdersProvider.notifier).stopTimer();
                LocalStorage.clearStore();
              },
              icon: const Icon(
                FlutterRemix.logout_circle_line,
                color: AppColors.iconColor,
              )),
          32.verticalSpace
        ],
      ),
    );
  }
}
