// ignore_for_file: must_be_immutable

import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/core/utils/app_validators.dart';
import 'package:garista_pos/src/core/utils/local_storage.dart';
import 'package:garista_pos/src/models/data/bag_data.dart';
import 'package:garista_pos/src/models/data/position_model.dart';
import 'package:garista_pos/src/models/data/table_model.dart';
import 'package:garista_pos/src/presentation/components/buttons/animation_button_effect.dart';
import 'package:garista_pos/src/presentation/components/components.dart';
import 'package:garista_pos/src/presentation/components/text_fields/custom_textformfield.dart';
import 'package:garista_pos/src/presentation/pages/main/riverpod/notifier/main_notifier.dart';
import 'package:garista_pos/src/presentation/pages/main/riverpod/provider/main_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/address/select_address_page.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/riverpod/notifier/right_side_notifier.dart';
import 'package:garista_pos/src/presentation/theme/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/riverpod/tables_provider.dart';

import 'riverpod/provider/right_side_provider.dart';
import 'riverpod/state/right_side_state.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/widgets/tables_list.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/widgets/tables_board.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/widgets/custom_refresher.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/widgets/custom_chair.dart';

class OrderInformation extends ConsumerStatefulWidget {
  final String? selectedTable; 
  final Function()? orderfunction;
  OrderInformation({Key? key, this.selectedTable, this.orderfunction}) : super(key: key);

  @override
  _OrderInformationState createState() => _OrderInformationState();
}

class _OrderInformationState extends ConsumerState<OrderInformation> {
    String? _currentSelectedTable; // Local variable to manage selected table

  @override
  void initState() {
    super.initState();
    _currentSelectedTable = widget.selectedTable;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tablesProvider.notifier).initial();
    });
  }
  // String? selectedTable;
  List listOfType = [
    TrKeys.delivery,
    TrKeys.pickup,
    TrKeys.dine,
  ];

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(rightSideProvider.notifier);
    final state = ref.watch(rightSideProvider);
    final BagData bag = state.bags[state.selectedBagIndex];
   final stateTable = ref.watch(tablesProvider);
    final notifierTable = ref.read(tablesProvider.notifier);

   List<DropdownMenuItem<String>> dropdownItems = stateTable.tableListData
        .map((table) {
      return DropdownMenuItem<String>(
        value: table?.id.toString(), // Assuming each table has an 'id'
        child: Text(table?.name ?? 'Unknown Table'), // Handle potential null 'name'
      );
    }).toList();

    print("The Selected Tables => ${widget.selectedTable}");


    return KeyboardDismisser(
      child: Container(
        width: 350.w,
        padding: REdgeInsets.symmetric(horizontal: 24.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    AppHelpers.getTranslation(TrKeys.order),
                    style: GoogleFonts.inter(
                        fontSize: 22.r, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // context.popRoute();
                    },
                    icon: const Icon(FlutterRemix.close_line),
                  ),
                ],
              ),
              16.verticalSpace,
               Padding(
                  padding: REdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                          flex: !stateTable.isListView ? 15 : 15,
                          child: Padding(
                              padding: REdgeInsets.only(left: 16, right: 17),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Select The Table :",
                                        style: GoogleFonts.inter(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  24.verticalSpace,
                              Stack(
                                    children: [
                                      SizedBox(
                                      height: 250.h,
                                      width: 350.w,
                                        child: Column(
                                      children: [
                                         Expanded(
                                          child: TableWidget(context),
                                         ),
                                      ]
                                        )
                                      ),
                                    ],
                                  ),
                                ],
                              ))),
                    ],
                  ),
                ),
                LoginButton(
                  isLoading: state.isOrderLoading,
                  title: AppHelpers.getTranslation(TrKeys.order),
                  titleColor: AppColors.white,
                  onPressed: widget.orderfunction
                )
            ],
          ),
        ),
      ),
    );
  }

 Widget TableWidget(BuildContext context) {
  // Ensure the final variables are assigned

  PositionModel positionModel = AppHelpers.fixedTable(4);

  final int top = positionModel.top; 
  final int bottom = positionModel.left;
  final int left =  positionModel.right;
  final int right =  positionModel.bottom;

  final double chairHeight = 54; // Example values, modify accordingly
  final double chairWidth = 140;
  final double chairSpace = 10;
  final double chairWithTableSpace = 6;
  final String title = "Table";
  final double? tableHeight;
  final double? tableWidth;
  final String type = "occupied"; // Example, replace accordingly

  // Compute withCount and heightCount
  int withCount = top > bottom ? top : bottom;
  int heightCount = left > right ? left : right;

  double width = withCount != 0 && withCount != 1
      ? (chairWidth * withCount) + ((withCount - 1) * chairSpace)
      : chairWidth * 1.6;
  double height = heightCount != 0 && heightCount != 1
      ? (chairWidth * heightCount) + ((heightCount - 1) * chairSpace)
      : chairWidth * 1.4;

  // Adjust width and height based on chair positions
  if (left != 0) {
    width += chairHeight + chairWithTableSpace;
  }
  if (right != 0) {
    width += chairHeight + chairWithTableSpace;
  }
  if (top != 0) {
    height += chairHeight;
  }
  if (bottom != 0) {
    height += chairHeight + chairWithTableSpace;
  }


  print("The Count => ${width} $height $chairHeight $chairSpace $chairWithTableSpace $withCount $heightCount ");
  return SizedBox(
    width:  width,
    height:  height,
    child: Column(
      children: [
        // Top chairs
        SizedBox(
            height: 24,
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                left: left != 0
                    ? chairHeight + chairSpace * 2.5
                    : top == 1
                        ? chairSpace * 2.5
                        : 0,
                right: right != 0
                    ? chairHeight + chairSpace * 2.5
                    : top == 1
                        ? chairSpace * 2.5
                        : 0,
              ),
              child: Row(
                children: List.generate(
                  top,
                  (index) => Expanded(
                    child: VerticalChair(
                      chairPosition: ChairPosition.top,
                      color: AppColors.GaristaColorBg,
                      chairSpace: index == 0 ? 0 : chairSpace,
                    ),
                  ),
                ),
              ),
            ),
          ),
                // Table content
        Expanded(
          child: Row(
            children: [
               SizedBox(
                height: left != 0
                      ? 100
                      : 0,
                width: left != 0 ? chairHeight : 0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: left,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CustomChair(
                      chairWidth: 80,
                      chairPosition: ChairPosition.left,
                      color: AppColors.GaristaColorBg,
                      chairSpace: index == 0 ? 0 : chairSpace,
                    );
                  },
                ),
                           // Table
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(chairWithTableSpace),
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 
                         withCount == 1 ? 2 : 0, vertical: heightCount == 1 ? 2 : 0,),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: type == TrKeys.occupied
                              ? Colors.red
                              : type == TrKeys.booked
                                  ? Colors.yellow
                                  : Colors.green,
                        ),
                        child: Text(
                          title,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                            color: type == TrKeys.occupied ||
                                    type == TrKeys.booked
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: withCount == 1 ? 14 : 15,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
             
              SizedBox(
                height: right != 0
                    ? 72
                    : 0,
                width: right != 0 ? chairHeight : 0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: right,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CustomChair(
                      chairWidth: 80,
                      chairPosition: ChairPosition.right,
                      color: AppColors.GaristaColorBg,
                      chairSpace: index == 0 ? 0 : chairSpace,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 25,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
              left: left != 0
                  ? chairHeight + chairSpace * 2.5
                  : bottom == 1
                      ? chairSpace * 2.5
                      : 0,
              right: right != 0
                  ? chairHeight + chairSpace * 2.5
                  : bottom == 1
                      ? chairSpace * 2.5
                      : 0,
            ),
            child: Row(
              children: List.generate(
                bottom,
                (index) => Expanded(
                  child: VerticalChair(
                    chairPosition: ChairPosition.bottom,
                                        color: AppColors.GaristaColorBg,
                    chairSpace: index == 0 ? 0 : chairSpace,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
