import 'dart:ffi';

import 'package:garista_pos/src/models/models.dart';
import 'package:garista_pos/src/presentation/components/custom_scaffold.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/profile/edit_profile/riverpod/provider/edit_profile_provider.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/profile/edit_profile/widgets/custom_date_textform.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/profile/edit_profile/widgets/label_and_textform.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/address/select_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/utils/app_helpers.dart';
import '../../../../../../core/utils/local_storage.dart';
import '../../../../../../models/data/location_data.dart';
import '../../../../../components/buttons/circle_choosing_button.dart';
import '../../../../../components/components.dart';
import '../../../../../components/custom_edit_profile_widget.dart';
import '../../../../../theme/app_colors.dart';
import 'package:intl/intl.dart' as intl;

import '../../right_side/riverpod/provider/right_side_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController email;
  late TextEditingController confirmPassword;
  late TextEditingController phoneNumber;
  late TextEditingController newPassword;
  late TextEditingController dateOfBirth;
  late TextEditingController personalPinCode;

  @override
  void initState() {
    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    phoneNumber = TextEditingController();
    dateOfBirth = TextEditingController();
    confirmPassword = TextEditingController();
    newPassword = TextEditingController();
    personalPinCode = TextEditingController();
    getInfo();

    super.initState();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phoneNumber.dispose();
    dateOfBirth.dispose();
    confirmPassword.dispose();
    newPassword.dispose();
    super.dispose();
  }


  getInfo() {
    firstName.text = LocalStorage.getUser()?.firstName ?? '';
    lastName.text = LocalStorage.getUser()?.lastName ?? '';
    phoneNumber.text = (LocalStorage.getUser()?.phone?.toString()) ?? '';
    email.text = LocalStorage.getUser()?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(editProfileProvider.notifier);
    final state = ref.watch(editProfileProvider);
    final stateRight = ref.watch(rightSideProvider);
    return CustomScaffold(
            body: (c) => Padding(
              padding:
                  REdgeInsets.only(left: 16, top: 24, bottom: 16, right: 16),
              child: Container(
                decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.only(left: 16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.r.verticalSpace,
                      Row(
                        children: [
                          CustomEditWidget(
                              image: state.url,
                              imagePath: state.imagePath,
                              isEmptyorNot:
                                  (LocalStorage.getUser()?.image?.isNotEmpty ??
                                          false) &&
                                      state.imagePath.isEmpty,
                              isEmptyorNot2: state.imagePath.isNotEmpty,
                              localStoreImage:
                                  LocalStorage.getUser()?.image ?? "",
                              onthisTap: () {
                                notifier.getPhoto();
                              }),
                          Padding(
                            padding: REdgeInsets.only(left: 28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${LocalStorage.getUser()?.firstName} ${LocalStorage.getUser()?.lastName?.substring(0, 1).toUpperCase()}.',
                                  style: GoogleFonts.inter(
                                      fontSize: 24.sp,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                8.r.verticalSpace,
                                // Text(
                                //   '${LocalStorage.getUser()?.}',
                                //   style: GoogleFonts.inter(
                                //       fontSize: 18.sp,
                                //       color: AppColors.iconColor,
                                //       fontWeight: FontWeight.bold),
                                // ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // if (LocalStorage.getUser()?.role == 'seller')
                          //   ConfirmButton(
                          //       title:
                          //           AppHelpers.getTranslation(TrKeys.editShop),
                          //       textColor: AppColors.black,
                          //       onTap: () {
                          //         notifier.setShopEdit(1);
                          //       }),
                          12.r.horizontalSpace,
                        ],
                      ),
                      42.r.verticalSpace,
                     
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: REdgeInsets.only(right: 80),
                              child: CustomColumnWidget(
                                controller: firstName,
                                trName:
                                    AppHelpers.getTranslation(TrKeys.firstname),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: REdgeInsets.only(right: 16),
                              child: CustomColumnWidget(
                                controller: lastName,
                                trName:
                                    AppHelpers.getTranslation(TrKeys.lastname),
                              ),
                            ),
                          )
                        ],
                      ),
                      24.r.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: REdgeInsets.only(right: 80),
                              child: CustomColumnWidget(
                                inputType: TextInputType.emailAddress,
                                controller: email,
                                trName: AppHelpers.getTranslation(TrKeys.email),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: REdgeInsets.only(right: 80),
                              child: CustomColumnWidget(
                                inputType: TextInputType.phone,
                                controller: phoneNumber,
                                trName: AppHelpers.getTranslation(TrKeys.phone),
                              ),
                            ),
                          ),
                        ],
                      ),
                      24.r.verticalSpace,
                      SizedBox(
                        width: 250.r,
                        child: LoginButton(
                            isLoading: state.isLoading,
                            title: AppHelpers.getTranslation(TrKeys.save),
                            onPressed: () {
                              notifier.editProfile(
                                  context,
                                  UserData(
                                    image: state.imagePath,
                                    firstName: firstName.text,
                                    lastName: lastName.text,
                                    email: email.text,
                                    phone: int.tryParse(phoneNumber.text),
                                  ));
                              if (newPassword.text.isNotEmpty &&
                                  confirmPassword.text.isNotEmpty) {
                                notifier.updatePassword(context,
                                    password: confirmPassword.text,
                                    confirmPassword: newPassword.text);
                              }
                              if (personalPinCode.text.isNotEmpty &&
                                  personalPinCode.text.length == 4) {
                                LocalStorage.setPinCode(personalPinCode.text);
                              }
                            }),
                      ),
                      24.r.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          );
        // : state.isShopEdit == 1
        //     ? const EditShop()
        //     : state.isShopEdit == 2
        //         ? SelectAddressPage(
        //             isShopEdit: true,
        //             location: LocationData(
        //                 latitude: double.tryParse(
        //                     stateRight.editShopData?.location?.latitude ??
        //                         AppConstants.demoLatitude.toString()),
        //                 longitude: double.tryParse(
        //                     stateRight.editShopData?.location?.longitude ??
        //                         AppConstants.demoLongitude.toString())),
        //             onSelect: (address) {
        //               notifier.setShopEdit(1);
        //               ref.read(rightSideProvider.notifier).updateShopData(
        //                     onSuccess: () {},
        //                     location: address.location,
        //                     displayName: address.address ?? '',
        //                   );
        //             },
        //           )
        //         : 
                
                // const DeliveryZonePage();
  }
}
