import 'dart:async';
import 'package:garista_pos/src/models/response/product_calculate_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/models/value_item.dart';
import '../../../../../../../core/constants/constants.dart';
import '../../../../../../../core/utils/utils.dart';
import '../../../../../../../models/data/edit_shop_data.dart';
import '../../../../../../../models/data/location_data.dart';
import '../../../../../../../models/models.dart';
import '../../../../../../../repository/repository.dart';
import '../../../../../../theme/theme.dart';
import '../state/right_side_state.dart';

class RightSideNotifier extends StateNotifier<RightSideState> {
  final UsersRepository _usersRepository;
  // final PaymentsRepository _paymentsRepository;
  // final ProductsRepository _productsRepository;
  // final OrdersRepository _ordersRepository;
  // final GalleryRepositoryFacade _galleryRepository;
  Timer? _searchUsersTimer;

  RightSideNotifier(this._usersRepository
      // this._paymentsRepository,
      // this._productsRepository,
      // this._ordersRepository,
      // this._galleryRepository
      )
      : super(const RightSideState());
  Timer? timer;

  Future<void> fetchBags() async {
    state = state.copyWith(isBagsLoading: true, bags: []);
    List<BagData> bags = LocalStorage.getBags();
    if (bags.isEmpty) {
      final BagData firstBag = BagData(index: 0, bagProducts: []);
      LocalStorage.setBags([firstBag]);
      bags = [firstBag];
    }
    state = state.copyWith(
      bags: bags,
      isBagsLoading: false,
      isActive: false,
      isPromoCodeLoading: false,
      coupon: null,
    );
  }

  void addANewBag() {
    List<BagData> newBags = List.from(state.bags);
    newBags.add(BagData(index: newBags.length, bagProducts: []));
    LocalStorage.setBags(newBags);
    state = state.copyWith(bags: newBags);
  }

  void setSelectedBagIndex(int index) {
    state = state.copyWith(
      selectedBagIndex: index,
    );
  }

  void removeBag(int index) {
    List<BagData> bags = List.from(state.bags);
    List<BagData> newBags = [];
    bags.removeAt(index);
    for (int i = 0; i < bags.length; i++) {
      newBags.add(BagData(index: i, bagProducts: bags[i].bagProducts));
    }
    LocalStorage.setBags(newBags);
    final int selectedIndex =
        state.selectedBagIndex == index ? 0 : state.selectedBagIndex;
    state = state.copyWith(bags: newBags, selectedBagIndex: selectedIndex);
  }

  void removeOrderedBag(BuildContext context) {
    List<BagData> bags = List.from(state.bags);
    List<BagData> newBags = [];
    bags.removeAt(state.selectedBagIndex);
    if (bags.isEmpty) {
      final BagData firstBag = BagData(index: 0, bagProducts: []);
      newBags = [firstBag];
    } else {
      for (int i = 0; i < bags.length; i++) {
        newBags.add(BagData(index: i, bagProducts: bags[i].bagProducts));
      }
    }
    LocalStorage.setBags(newBags);
    state = state.copyWith(
        bags: newBags,
        selectedBagIndex: 0,
        selectedUser: null,
        selectedAddress: null,
        selectedCurrency: null,
        selectedPayment: null,
        orderType: TrKeys.pickup);
    setInitialBagData(context, newBags[0]);
  }

  Future<void> fetchUsers({VoidCallback? checkYourNetwork}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(
        isUsersLoading: true,
        dropdownUsers: [],
        users: [],
      );
      final response = await _usersRepository.searchUsers(
          query: state.usersQuery.isEmpty ? null : state.usersQuery);
      response.when(
        success: (data) async {
          final List<UserData> users = data.users ?? [];
          List<DropDownItemData> dropdownUsers = [];
          for (int i = 0; i < users.length; i++) {
            dropdownUsers.add(
              DropDownItemData(
                index: i,
                title: '${users[i].firstName} ${users[i].lastName ?? ""}',
              ),
            );
          }
          state = state.copyWith(
            isUsersLoading: false,
            users: users,
            dropdownUsers: dropdownUsers,
          );
        },
        failure: (failure) {
          state = state.copyWith(isUsersLoading: false);
          debugPrint('==> get users failure: $failure');
        },
      );
    } else {
      checkYourNetwork?.call();
    }
  }

  Future<void> getPhoto(
      {bool isLogoImage = false, required BuildContext context}) async {
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
      // ignore: use_build_context_synchronously
      // await updateShopImage(context, croppedFile?.path ?? "", isLogoImage);
      // state = isLogoImage
      //     ? state.copyWith(logoImagePath: croppedFile?.path ?? "")
      //     : state.copyWith(backImagePath: croppedFile?.path ?? "");
    }
  }

  void setUsersQuery(BuildContext context, String query) {
    if (state.usersQuery == query) {
      return;
    }
    state = state.copyWith(usersQuery: query.trim());

    if (_searchUsersTimer?.isActive ?? false) {
      _searchUsersTimer?.cancel();
    }
    _searchUsersTimer = Timer(
      const Duration(milliseconds: 500),
      () {
        state = state.copyWith(users: [], dropdownUsers: []);
        fetchUsers(
          checkYourNetwork: () {
            AppHelpers.showSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
            );
          },
        );
      },
    );
  }

  void setSelectedUser(BuildContext context, int index) {
    final user = state.users[index];
    final bags = LocalStorage.getBags();
    final bag = bags[state.selectedBagIndex].copyWith();
    bags[state.selectedBagIndex] = bag;
    LocalStorage.setBags(bags);
    state = state.copyWith(
      bags: bags,
      selectedUser: user,
    );
    fetchUserDetails(
      checkYourNetwork: () {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      },
    );
    setUsersQuery(context, '');
  }

  void removeSelectedUser() {
    final List<BagData> bags = List.from(LocalStorage.getBags());
    final BagData bag = bags[state.selectedBagIndex].copyWith();
    bags[state.selectedBagIndex] = bag;
    LocalStorage.setBags(bags);
    state = state.copyWith(
      bags: bags,
      selectedUser: null,
    );
  }

  Future<void> fetchUserDetails({VoidCallback? checkYourNetwork}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isUserDetailsLoading: true);
      final response = await _usersRepository.getUserDetails('');
      response.when(
        success: (data) async {
          state = state.copyWith(
            isUserDetailsLoading: false,
            selectedUser: data.data,
          );
        },
        failure: (failure) {
          state = state.copyWith(isUserDetailsLoading: false);
          debugPrint('==> get users details failure: $failure');
        },
      );
    } else {
      checkYourNetwork?.call();
    }
  }

  void setSelectedOrderType(String? type) {
    state = state.copyWith(orderType: type ?? state.orderType);
  }

  void setInitialBagData(BuildContext context, BagData bag) {
    fetchCarts(
      checkYourNetwork: () {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      },
    );
  }

  Future<void> fetchCarts(
      {VoidCallback? checkYourNetwork, bool isNotLoading = false}) async {
    final connected = await AppConnectivity.connectivity();

    if (connected) {
      if (isNotLoading) {
        state = state.copyWith(
          isButtonLoading: true,
        );
      } else {
        state = state.copyWith(
          isProductCalculateLoading: true,
          paginateResponse: null,
          bags: LocalStorage.getBags(),
        );
      }

      final List<BagProductData> bagProducts =
          LocalStorage.getBags()[state.selectedBagIndex].bagProducts ?? [];

      if (bagProducts.isNotEmpty) {
        // Add logic here if needed, for example, summing product prices locally
        // or setting a flag that items are present. Since we are not calling the API,
        // you could handle any further processing here.

        // Example: Update state with a mock or local response
        state = state.copyWith(
          isButtonLoading: false,
          isProductCalculateLoading: true,
          // paginateResponse: bagProducts, // You can adjust based on actual state data structure
        );
      } else {
        // Handle case when there are no products in the cart
        state = state.copyWith(
          isButtonLoading: false,
          isProductCalculateLoading: false,
        );
      }
    } else {
      checkYourNetwork?.call();
    }
  }

  void setDate(DateTime date) {
    state = state.copyWith(orderDate: date);
  }

  void setTime(TimeOfDay time) {
    state = state.copyWith(orderTime: time);
  }

  void clearBag(BuildContext context) {
    var newPagination = state.paginateResponse?.copyWith(stocks: []);
    state = state.copyWith(paginateResponse: newPagination);
    List<BagData> bags = List.from(LocalStorage.getBags());
    bags[state.selectedBagIndex] =
        bags[state.selectedBagIndex].copyWith(bagProducts: []);
    LocalStorage.setBags(bags);
  }

  void deleteProductFromBag(BuildContext context, BagProductData bagProduct) {
    final List<BagProductData> bagProducts = List.from(
        LocalStorage.getBags()[state.selectedBagIndex].bagProducts ?? []);
    int index = 0;
    // for (int i = 0; i < bagProducts.length; i++) {
    //   if (bagProducts[i].stockId == bagProduct.stockId) {
    //     index = i;
    //     break;
    //   }
    // }
    bagProducts.removeAt(index);
    List<BagData> bags = List.from(LocalStorage.getBags());
    bags[state.selectedBagIndex] =
        bags[state.selectedBagIndex].copyWith(bagProducts: bagProducts);
    LocalStorage.setBags(bags);
    fetchCarts(
      checkYourNetwork: () {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      },
    );
  }

  void deleteProductCount({
    required BagProductData? bagProductData,
    required int productIndex,
  }) {
    List<ProductData>? listOfProduct = state.paginateResponse?.stocks;
    listOfProduct?.removeAt(productIndex);
    PriceDate? data = state.paginateResponse;
    PriceDate? newData = data?.copyWith(stocks: listOfProduct);
    state = state.copyWith(paginateResponse: newData);
    final List<BagProductData> bagProducts =
        LocalStorage.getBags()[state.selectedBagIndex].bagProducts ?? [];
    bagProducts.removeAt(productIndex);

    List<BagData> bags = List.from(LocalStorage.getBags());
    bags[state.selectedBagIndex] =
        bags[state.selectedBagIndex].copyWith(bagProducts: bagProducts);
    LocalStorage.setBags(bags);

    fetchCarts(isNotLoading: true);
  }
}