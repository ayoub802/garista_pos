import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/core/utils/local_storage.dart';
import 'package:garista_pos/src/models/response/income_statistic_response.dart';
import 'package:garista_pos/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/income/riverpod/income_notifier.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/income/riverpod/income_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/income/riverpod/income_state.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/income/widgets/statistics_page.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../../generated/assets.dart';
import '../../../../components/custom_scaffold.dart';
import 'widgets/chart_page.dart';
import '../../../../components/filter_screen.dart';
import 'widgets/pie_chart.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class InComePage extends ConsumerStatefulWidget {
  const InComePage({super.key});

  @override
  ConsumerState<InComePage> createState() => _InComePageState();
}

class _InComePageState extends ConsumerState<InComePage> {
  List list = [
    TrKeys.day,
    TrKeys.week, 
    TrKeys.month,
  ];

      final DatabaseReference _notificationsRef =
      FirebaseDatabase.instance.ref("orders");

   StreamSubscription<DatabaseEvent>? _firebaseSubscription;

  @override
  void initState() {
    _subscribeToFirebase();
    _initializeFirstNotification();
    super.initState();
  }

    void _initializeFirstNotification() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(incomeProvider.notifier)
        ..fetchIncomeCarts()
        ..fetchIncomeCharts()
        ..fetchIncomeStatistic();
    });
    }
  void _subscribeToFirebase() {
    // Listen to Firebase Realtime Database changes
    _firebaseSubscription =
        _notificationsRef.onValue.listen((DatabaseEvent event) {
      if (!mounted) return; // Make sure the widget is still active

      if (event.snapshot.exists) {
        // Safely refresh notifications only if the widget is still active
        _refreshNotifications();
      }
    });
  }

void _refreshNotifications() {
    if (!mounted) return; // Avoid accessing ref after the widget is disposed
       ref.read(incomeProvider.notifier)
        ..fetchIncomeCarts()
        ..fetchIncomeCharts()
        ..fetchIncomeStatistic();
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incomeProvider);
    final event = ref.read(incomeProvider.notifier);

    // print(
    //     "The State of INCOME ${state?.incomeCart?.average} ${state?.incomeCart?.orders} ${state?.incomeCart?.revenue} ${state?.incomeCart?.revenuePercent} ${state?.incomeCart?.revenueType} ${state?.incomeCart?.averageType}");
    return CustomScaffold(
      body: (colors) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppHelpers.getTranslation(TrKeys.income),
                style: GoogleFonts.inter(
                    fontSize: 22.r, fontWeight: FontWeight.w600),
              ),
              16.verticalSpace,
              _filter(state, event),
              16.verticalSpace,
              _carts(state),
              16.verticalSpace,
              ChartPage(
                isDay: state.selectType == TrKeys.day,
                price: state.prices,
                chart: state.incomeCharts ?? [],
                times: state.time,
              ),
              16.verticalSpace,
              Row(
                children: [
                  PieChartPage(
                    statistic:
                        state.incomeStatistic ?? IncomeStatisticResponse(),
                  ),
                  16.horizontalSpace,
                  StatisticPage(statistic: state.incomeStatistic)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _carts(IncomeState state) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.revenue),
                      style: GoogleFonts.inter(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.revenueColor,
                          ),
                          padding: EdgeInsets.all(10.r),
                          child: SvgPicture.asset(Assets.svgRevenue),
                        ),
                        24.horizontalSpace,
                        Text(
                          "${state.incomeCart?.revenue ?? 0} ${LocalStorage.getBrand()?.currency}",
                          style: GoogleFonts.inter(
                              fontSize: 24.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    state.incomeCart?.revenueType == TrKeys.plus
                        ? Icon(
                            FlutterRemix.arrow_up_line,
                            color: AppColors.GaristaColorBg,
                            size: 18.r,
                          )
                        : Icon(
                            FlutterRemix.arrow_down_line,
                            color: AppColors.red,
                            size: 18.r,
                          ),
                    4.horizontalSpace,
                    Text(
                      "${state.incomeCart?.revenuePercent?.ceil() ?? 0}%",
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: state.incomeCart?.revenueType == TrKeys.plus
                              ? AppColors.GaristaColorBg
                              : AppColors.red),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.orders),
                      style: GoogleFonts.inter(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.GaristaColorBg,
                          ),
                          padding: EdgeInsets.all(10.r),
                          child: const Icon(
                            FlutterRemix.shopping_cart_fill,
                            color: AppColors.white,
                          ),
                        ),
                        24.horizontalSpace,
                        Text(
                          '${state.incomeCart?.orders ?? 0}',
                          style: GoogleFonts.inter(
                              fontSize: 24.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    state.incomeCart?.ordersType == TrKeys.plus
                        ? Icon(
                            FlutterRemix.arrow_up_line,
                            color: AppColors.GaristaColorBg,
                            size: 18.r,
                          )
                        : Icon(
                            FlutterRemix.arrow_down_line,
                            color: AppColors.red,
                            size: 18.r,
                          ),
                    4.horizontalSpace,
                    Text(
                      "${state.incomeCart?.ordersPercent?.ceil() ?? 0}%",
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: state.incomeCart?.ordersType == TrKeys.plus
                              ? AppColors.GaristaColorBg
                              : AppColors.red),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 30.r),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.white),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppHelpers.getTranslation(TrKeys.average),
                      style: GoogleFonts.inter(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                    20.verticalSpace,
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.black,
                          ),
                          padding: EdgeInsets.all(10.r),
                          child: SvgPicture.asset(Assets.svgAverage),
                        ),
                        24.horizontalSpace,
                        Text(
                          "${(state.incomeCart?.average ?? 0).toStringAsFixed(3)}",
                          style: GoogleFonts.inter(
                              fontSize: 24.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    state.incomeCart?.averageType == TrKeys.plus
                        ? Icon(
                            FlutterRemix.arrow_up_line,
                            color: AppColors.GaristaColorBg,
                            size: 18.r,
                          )
                        : Icon(
                            FlutterRemix.arrow_down_line,
                            color: AppColors.red,
                            size: 18.r,
                          ),
                    4.horizontalSpace,
                    Text(
                      "${state.incomeCart?.averagePercent?.ceil() ?? 0}%",
                      style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: state.incomeCart?.averageType == TrKeys.plus
                              ? AppColors.GaristaColorBg
                              : AppColors.red),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _filter(IncomeState state, IncomeNotifier event) {
    return Row(
      children: [
        SvgPicture.asset(Assets.svgMenu),
        8.horizontalSpace,
        ...list.map(
          (e) => GestureDetector(
            onTap: () => event.changeIndex(e),
            child: AnimationButtonEffect(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 18.r),
                margin: EdgeInsets.only(right: 8.r),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: state.selectType == e
                        ? AppColors.GaristaColorBg
                        : AppColors.white),
                child: Text(
                  AppHelpers.getTranslation(e),
                  style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: state.selectType == e
                          ? AppColors.white
                          : AppColors.black),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            event
              ..fetchIncomeCarts()
              ..fetchIncomeCharts()
              ..fetchIncomeStatistic();
          },
          child: AnimationButtonEffect(
            child: Container(
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.all(10.r),
                child: const Icon(FlutterRemix.restart_line)),
          ),
        ),
        8.horizontalSpace,
        InkWell(
          onTap: () {
            AppHelpers.showAlertDialog(
                context: context,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: const FilterScreen()));
          },
          child: AnimationButtonEffect(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 16.r),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  const Icon(FlutterRemix.calendar_check_line),
                  16.horizontalSpace,
                  Text(
                    state.start == null
                        ? AppHelpers.getTranslation(TrKeys.startEnd)
                        : "${DateFormat("MMM d,yyyy").format(state.start ?? DateTime.now())} - ${DateFormat("MMM d,yyyy").format(state.end ?? DateTime.now())}",
                    style: GoogleFonts.inter(fontSize: 14.sp),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
