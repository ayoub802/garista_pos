// ignore_for_file: must_be_immutable

import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/core/utils/app_validators.dart';
import 'package:garista_pos/src/core/utils/local_storage.dart';
import 'package:garista_pos/src/models/data/bag_data.dart';
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
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/widgets/custom_table.dart';

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
                                         DropdownButton<String>(
                                          isExpanded: true,
                                          value: _currentSelectedTable , // Current selected table
                                          hint: Text("Selecte a Table"),
                                          items: dropdownItems, // The dropdown menu items
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _currentSelectedTable = newValue; // Update selected table
                                            });
                                            // Additional logic to handle table selection can be added here
                                          },
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

}
