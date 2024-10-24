import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:garista_pos/src/models/models.dart';
import 'package:garista_pos/src/models/response/edit_profile.dart';
import 'package:garista_pos/src/presentation/pages/main/riverpod/provider/main_provider.dart';
import 'package:garista_pos/src/presentation/theme/theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../../core/constants/constants.dart';
import '../../../../../../../../core/utils/app_connectivity.dart';
import '../../../../../../../../core/utils/app_helpers.dart';
import '../../../../../../../../core/utils/local_storage.dart';
import '../../../../../../../../repository/gallery.dart';
import '../../../../../../../components/dialogs/successfull_dialog.dart';
import '../state/edit_profile_state.dart';

class EditProfileNotifier extends StateNotifier<EditProfileState> {

EditProfileNotifier(EditProfileState state) : super(state);

  Future<void> getPhoto() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.white,
            toolbarWidgetColor: AppColors.black,
            initAspectRatio: CropAspectRatioPreset.original,
          ),
          IOSUiSettings(title: 'Image Cropper', minimumAspectRatio: 1),
        ],
      );
      state = state.copyWith(imagePath: croppedFile?.path ?? "");
    }
  }

  changeIndex(int index) {
    state = state.copyWith(selectIndex: index);
  }
  setShopEdit(int isShopEdit) {
    state = state.copyWith(isShopEdit: isShopEdit);
  }
  void setShowPassword(bool show) {
    state = state.copyWith(showPassword: show);
  }

  void setShowOldPassword(bool show) {
    state = state.copyWith(showOldPassword: show);
  }

  void setShowPersonalPincode(bool show) {
    state = state.copyWith(showPincode: show);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setBirth(String birth) {
    state = state.copyWith(birth: birth);
  }

  Future<void> editProfile(BuildContext context, UserData user) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      // if (state.imagePath.isNotEmpty) {
      //   // ignore: use_build_context_synchronously
      //   await updateProfileImage(context, state.imagePath);
      // }

      print("The User => ${user.phone}");

      final response = await usersRepository.editProfile(
          user: EditProfile(
        first_name: state.firstName.isEmpty ? user.firstName : state.firstName,
        last_name: state.lastName.isEmpty ? user.lastName : state.lastName,
        phone: state.phone.isEmpty ? user.phone?.toString() : state.phone,
        // images: state.url.isEmpty ? user.image ?? "" : state.url,
        // gender: state.gender,
      ));
      response.when(
        success: (data) {
          LocalStorage.setUser(data.data);

          state = state.copyWith(
            userData: data.data,
            isLoading: false,
            isSuccess: true,
          );

          showDialog(
              context: context,
              builder: (_) => Dialog(child: Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return SuccessfullDialog(
                          title:
                              AppHelpers.getTranslation(TrKeys.profileEdited),
                          content: AppHelpers.getTranslation(TrKeys.goToHome),
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(mainProvider.notifier).changeIndex(0);
                          });
                    },
                  )));
        },
        failure: (failure) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showSnackBar(
            context,
            AppHelpers.getTranslation(failure.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  Future<void> updatePassword(BuildContext context,
      {required String password, required String confirmPassword}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await usersRepository.updatePassword(
        password: password,
        passwordConfirmation: confirmPassword,
      );
      response.when(
        success: (data) async {
          state = state.copyWith(isLoading: false, isSuccess: true);
          // context.replaceRoute(const MainRoute());
        },
        failure: (failure) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showSnackBar(
            context,
            AppHelpers.getTranslation(failure.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }


}
