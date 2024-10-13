import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:garista_pos/src/presentation/components/custom_checkbox.dart';
import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../models/models.dart';
import '../../../../components/components.dart';
import '../../../../theme/theme.dart';
import '../right_side/riverpod/provider/right_side_provider.dart';
import 'provider/add_product_provider.dart';
import 'widgets/extras/color_extras.dart';
import 'widgets/extras/image_extras.dart';
import 'widgets/extras/text_extras.dart';
import 'widgets/extras/topping_options.dart';
import 'widgets/w_ingredient.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  final ProductData? product;

  const AddProductDialog({super.key, required this.product});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  late double totalPrice;
  int quantity = 1;
  List<Map<String, dynamic>> selectedToppings = [];
  List<Map<String, dynamic>> selectedVariants = [];
  List<Map<String, dynamic>> selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addProductProvider.notifier).setProduct(
            widget.product,
            ref.watch(rightSideProvider).selectedBagIndex,
          );
    });
    totalPrice = double.tryParse(widget.product?.price ?? '0.0') ?? 0.0;
    selectedVariants = getSelectedVariants();
    selectedToppings = getSelectedToppings();
    selectedIngredients = getSelectedIngredients();
  }

  void updateTotalPrice() {
    double productPrice =
        double.tryParse(widget.product?.price ?? '0.0') ?? 0.0;
    setState(() {
      totalPrice = productPrice * quantity;
    });
  }

  // Increment the quantity
  void incrementQuantity() {
    setState(() {
      quantity++;
      updateTotalPrice();
    });
  }

  // Decrement the quantity
  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        updateTotalPrice();
      });
    }
  }

  List<Map<String, dynamic>> getSelectedToppings() {
    List<Map<String, dynamic>> selectedToppings = [];

    // Iterate through the toppings of the product
    for (var topping in widget.product?.toppings ?? []) {
      List<Map<String, dynamic>> selectedOptions = [];

      // Iterate through the options of each topping
      for (var option in topping.options ?? []) {
        // Check if the option is selected
        if (option.isSelected) {
          selectedOptions.add({
            'name': option.name,
            'price': option.price,
          });
        }
      }

      // If there are selected options, add the topping to the list
      if (selectedOptions.isNotEmpty) {
        selectedToppings.add({
          'id': topping.id,
          'name': topping.name, // Change here
          'options': selectedOptions, // Change here
        });
      }
    }

    return selectedToppings;
  }

  List<Map<String, dynamic>> getSelectedVariants() {
    List<Map<String, dynamic>> selectedVariants = [];

    // Iterate through the toppings of the product
    for (var variant in widget.product?.extraVariants ?? []) {
      List<Map<String, dynamic>> selectedOptions = [];

      // Iterate through the options of each variant
      for (var option in variant.options ?? []) {
        // Check if the option is selected
        if (option.isSelected) {
          selectedOptions.add({
            'name': option.name,
            'price': option.price,
          });
        }
      }

      // If there are selected options, add the variant to the list
      if (selectedOptions.isNotEmpty) {
        selectedVariants.add({
          'id': variant.id,
          'name': variant.name, // Change here
          'options': selectedOptions, // Change here
        });
      }
    }

    return selectedVariants;
  }

  List<Map<String, dynamic>> getSelectedIngredients() {
    List<Map<String, dynamic>> selectedIngredients = [];

    // Iterate through the ingredients and add the selected ones
    for (var ingredient in widget.product?.ingredients ?? []) {
      if (ingredient.active == true) {
        selectedIngredients.add({
          'name': ingredient.name,
        });
      }
    }

    return selectedIngredients;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addProductProvider);
    final rightSideState = ref.watch(rightSideProvider);
    final notifier = ref.read(addProductProvider.notifier);
    final rightSideNotifier = ref.read(rightSideProvider.notifier);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.white,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 1.6,
          maxWidth: MediaQuery.of(context).size.width / 1.6,
        ),
        padding: REdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.verticalSpace,
              Row(
                children: [
                  const SizedBox.shrink(),
                  const Spacer(),
                  CircleIconButton(
                    size: 60,
                    backgroundColor: AppColors.transparent,
                    iconData: FlutterRemix.close_circle_line,
                    iconColor: AppColors.black,
                    onTap: context.popRoute,
                  ),
                ],
              ),
              6.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImage(
                        imageUrl: widget.product?.image1,
                        width: 350.w,
                        height: 350.w,
                      ),
                      24.verticalSpace,
                    ],
                  ),
                  32.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product?.name}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 22.sp,
                            color: AppColors.black,
                            letterSpacing: -0.4,
                          ),
                        ),
                        8.verticalSpace,
                        Row(
                          children: [
                            InkWell(
                              onTap: decrementQuantity,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.removeButtonColor),
                                child: Icon(
                                  Icons.remove,
                                  color: AppColors.outlineButtonBorder,
                                ),
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              "${quantity}",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                              ),
                            ),
                            8.horizontalSpace,
                            InkWell(
                              onTap: incrementQuantity,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.addButtonColor),
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width / 1.6 - 370.w,
                          child: Text(
                            '${widget.product?.desc}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              color: AppColors.iconColor,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                        8.verticalSpace,
                        widget.product?.toppings?.isNotEmpty ?? false
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6 -
                                    370.w,
                                child: Divider(
                                  color: AppColors.black.withOpacity(0.2),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width / 1.6 - 370.w,
                          child: ListView.builder(
                            physics: const CustomBouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.product?.toppings?.length ?? 0,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final ToppingData topping =
                                  widget.product!.toppings![index];

                              bool hasValidOptions = topping.options?.any(
                                      (option) =>
                                          option.name != null &&
                                          option.price != null) ??
                                  false;

                              // If no valid options are found, don't display this topping
                              if (!hasValidOptions) {
                                return SizedBox
                                    .shrink(); // Don't display this topping
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.white,
                                ),
                                padding: REdgeInsets.symmetric(vertical: 6),
                                margin: REdgeInsets.only(bottom: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          topping.name ?? ' ',
                                          style: GoogleFonts.inter(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        topping.required == true
                                            ? Container(
                                                padding: REdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical:
                                                        6), // Padding around the text
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .GaristaColorBg, // Set your desired background color here
                                                  borderRadius:
                                                      BorderRadius.circular(10
                                                          .r), // Add rounded corners
                                                ),
                                                child: Text(
                                                  topping.required == true
                                                      ? 'Required'
                                                      : '',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .white, // Text color
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    15.verticalSpace,
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: topping.options?.length ?? 0,
                                      itemBuilder: (context, optionIndex) {
                                        final ToppingOptionData option =
                                            topping.options![optionIndex];
                                        print(
                                            "Topping Option: ${option.name}, Price: \$${option.name}, Selected: ${option.price}");

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 12
                                                  .h), // Adjust the gap between items here
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (topping.multipleSelection ==
                                                    true) {
                                                  // Multiple selection allowed (toggle individual options)
                                                  option.isSelected =
                                                      !option.isSelected;
                                                  if (option.isSelected) {
                                                    totalPrice +=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                  } else {
                                                    totalPrice -=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                  }
                                                } else {
                                                  // Single selection: deselect if already selected, otherwise deselect others
                                                  if (option.isSelected) {
                                                    totalPrice -=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                    option.isSelected =
                                                        false; // Deselect the current option
                                                  } else {
                                                    // Deselect all other options
                                                    for (var opt
                                                        in topping.options!) {
                                                      if (opt.isSelected) {
                                                        totalPrice -=
                                                            double.tryParse(
                                                                    opt.price ??
                                                                        '0') ??
                                                                0;
                                                      }
                                                      opt.isSelected = false;
                                                    }
                                                    totalPrice +=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                    option.isSelected =
                                                        true; // Select the current option
                                                  }
                                                }
                                                selectedToppings =
                                                    getSelectedToppings();
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CustomCheckbox(
                                                      isActive:
                                                          option.isSelected,
                                                      onTap: () {
                                                        setState(() {
                                                          if (topping
                                                                  .multipleSelection ==
                                                              true) {
                                                            // Multiple selection allowed (toggle individual options)
                                                            option.isSelected =
                                                                !option
                                                                    .isSelected;
                                                            if (option
                                                                .isSelected) {
                                                              totalPrice +=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                            } else {
                                                              totalPrice -=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                            }
                                                          } else {
                                                            // Single selection: deselect if already selected, otherwise deselect others
                                                            if (option
                                                                .isSelected) {
                                                              totalPrice -=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                              option.isSelected =
                                                                  false; // Deselect the current option
                                                            } else {
                                                              // Deselect all other options
                                                              for (var opt
                                                                  in topping
                                                                      .options!) {
                                                                if (opt
                                                                    .isSelected) {
                                                                  totalPrice -=
                                                                      double.tryParse(opt.price ??
                                                                              '0') ??
                                                                          0;
                                                                }
                                                                opt.isSelected =
                                                                    false;
                                                              }
                                                              totalPrice +=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                              option.isSelected =
                                                                  true; // Select the current option
                                                            }
                                                          }
                                                          selectedToppings =
                                                              getSelectedToppings();
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      option.name ?? '',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    // Price display
                                                    Text(
                                                      '${double.tryParse(option.price ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    8.horizontalSpace,
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    8.verticalSpace,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                              1.6 -
                                          370.w,
                                      child: Divider(
                                        color: AppColors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        widget.product?.extraVariants?.isNotEmpty ?? false
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width / 1.6 -
                                    370.w,
                                child: Divider(
                                  color: AppColors.black.withOpacity(0.2),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width / 1.6 - 370.w,
                          child: ListView.builder(
                            physics: const CustomBouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                widget.product?.extraVariants?.length ?? 0,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final VariantData variant =
                                  widget.product!.extraVariants![index];
                              print(
                                  "Variant Option: ${variant.name}, Price: \$${variant.required}, Selected: ${variant.multipleSelection}");

                              bool hasValidOptions = variant.options?.any(
                                      (option) =>
                                          option.name != null &&
                                          option.price != null) ??
                                  false;

                              // If no valid options are found, don't display this topping
                              if (!hasValidOptions) {
                                return SizedBox
                                    .shrink(); // Don't display this topping
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: AppColors.white,
                                ),
                                padding: REdgeInsets.symmetric(vertical: 6),
                                margin: REdgeInsets.only(bottom: 6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          variant.name ?? ' ',
                                          style: GoogleFonts.inter(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.black,
                                            letterSpacing: -0.4,
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        variant.required == true
                                            ? Container(
                                                padding: REdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical:
                                                        6), // Padding around the text
                                                decoration: BoxDecoration(
                                                  color: AppColors
                                                      .GaristaColorBg, // Set your desired background color here
                                                  borderRadius:
                                                      BorderRadius.circular(10
                                                          .r), // Add rounded corners
                                                ),
                                                child: Text(
                                                  variant.required == true
                                                      ? 'Required'
                                                      : '',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .white, // Text color
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                    15.verticalSpace,
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: variant.options?.length ?? 0,
                                      itemBuilder: (context, optionIndex) {
                                        final VariantOptionData option =
                                            variant.options![optionIndex];
                                        print(
                                            "Variant Option: ${option.name}, Price: \$${option.name}, Selected: ${option.price}");

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 12
                                                  .h), // Adjust the gap between items here
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                if (variant.multipleSelection ==
                                                    true) {
                                                  // Multiple selection allowed (toggle individual options)
                                                  option.isSelected =
                                                      !option.isSelected;
                                                  if (option.isSelected) {
                                                    totalPrice +=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                  } else {
                                                    totalPrice -=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                  }
                                                } else {
                                                  // Single selection: deselect if already selected, otherwise deselect others
                                                  if (option.isSelected) {
                                                    totalPrice -=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                    option.isSelected =
                                                        false; // Deselect the current option
                                                  } else {
                                                    // Deselect all other options
                                                    for (var opt
                                                        in variant.options!) {
                                                      if (opt.isSelected) {
                                                        totalPrice -=
                                                            double.tryParse(
                                                                    opt.price ??
                                                                        '0') ??
                                                                0;
                                                      }
                                                      opt.isSelected = false;
                                                    }
                                                    totalPrice +=
                                                        double.tryParse(
                                                                option.price ??
                                                                    '0') ??
                                                            0;
                                                    option.isSelected =
                                                        true; // Select the current option
                                                  }
                                                }
                                                selectedVariants =
                                                    getSelectedVariants();
                                                print(
                                                    "Selected Variants: $selectedVariants");
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    CustomCheckbox(
                                                      isActive:
                                                          option.isSelected,
                                                      onTap: () {
                                                        setState(() {
                                                          if (variant
                                                                  .multipleSelection ==
                                                              true) {
                                                            // Multiple selection allowed (toggle individual options)
                                                            option.isSelected =
                                                                !option
                                                                    .isSelected;
                                                            if (option
                                                                .isSelected) {
                                                              totalPrice +=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                            } else {
                                                              totalPrice -=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                            }
                                                          } else {
                                                            // Single selection: deselect if already selected, otherwise deselect others
                                                            if (option
                                                                .isSelected) {
                                                              totalPrice -=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                              option.isSelected =
                                                                  false; // Deselect the current option
                                                            } else {
                                                              // Deselect all other options
                                                              for (var opt
                                                                  in variant
                                                                      .options!) {
                                                                if (opt
                                                                    .isSelected) {
                                                                  totalPrice -=
                                                                      double.tryParse(opt.price ??
                                                                              '0') ??
                                                                          0;
                                                                }
                                                                opt.isSelected =
                                                                    false;
                                                              }
                                                              totalPrice +=
                                                                  double.tryParse(
                                                                          option.price ??
                                                                              '0') ??
                                                                      0;
                                                              option.isSelected =
                                                                  true; // Select the current option
                                                            }
                                                          }
                                                          selectedVariants =
                                                              getSelectedVariants();
                                                          print(
                                                              "Selected Variants: $selectedVariants");
                                                        });
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      option.name ?? '',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    // Price display
                                                    Text(
                                                      '${double.tryParse(option.price ?? '0')?.toStringAsFixed(2) ?? '0.00'}',
                                                      style: GoogleFonts.inter(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors.black,
                                                      ),
                                                    ),
                                                    8.horizontalSpace,
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    8.verticalSpace,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                              1.6 -
                                          370.w,
                                      child: Divider(
                                        color: AppColors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        8.verticalSpace,
                        SizedBox(
                          width:
                              MediaQuery.of(context).size.width / 1.6 - 370.w,
                          child: WIngredientScreen(
                            list: widget.product?.ingredients ?? [],
                            onChange: (int value) {
                              notifier.updateIngredient(context, value);
                              selectedIngredients = getSelectedIngredients();
                              print(
                                  "Selected Ingredients: $selectedIngredients");
                            },
                            add: (int value) {
                              // notifier.addIngredient(context, value);
                            },
                            remove: (int value) {
                              // notifier.removeIngredient(context, value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              const Divider(),
              10.verticalSpace,
              Row(
                children: [
                  SizedBox(
                    width: 120.w,
                    child: LoginButton(
                      isLoading: state.isLoading,
                      title: AppHelpers.getTranslation(TrKeys.add),
                      onPressed: () {
                        notifier.addProductToBag(
                            context,
                            rightSideState.selectedBagIndex,
                            rightSideNotifier,
                            quantity,
                            totalPrice,
                            widget.product,
                            selectedToppings,
                            selectedVariants,
                            selectedIngredients);
                        // context.popRoute();
                      },
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price :',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                          letterSpacing: -14 * 0.02,
                        ),
                      ),
                      4.verticalSpace,
                      Row(
                        children: [
                          Text(
                            '${totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                              letterSpacing: -14 * 0.02,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
