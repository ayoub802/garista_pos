import 'package:garista_pos/src/models/data/addons_data.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/right_side/riverpod/notifier/right_side_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/constants.dart';
import '../../../../../../core/utils/utils.dart';
import '../../../../../../models/models.dart';
import '../riverpod/add_product_state.dart';

class AddProductNotifier extends StateNotifier<AddProductState> {
  AddProductNotifier() : super(const AddProductState());

  void setProduct(ProductData? product, int bagIndex) {
    state = state.copyWith(
      isLoading: false,
      product: product,
      stockCount: 0,
    );
  }

  void addProductToBag(
    BuildContext context,
    int bagIndex,
    RightSideNotifier rightSideNotifier,
    ProductData? product, // The product can be null
  ) {
    // LocalStorage.clearBags();
    if (product == null) {
      AppHelpers.showSnackBar(context, 'Product is null');
      return;
    }

    // Check if the product ID is not null before using it
    final productId = product.id; // Assuming this is an int
    if (productId == null) {
      AppHelpers.showSnackBar(context, 'Product ID is null');
      return;
    }

    final List<BagProductData> bagProducts =
        LocalStorage.getBags()[bagIndex].bagProducts ?? [];

    bool productExists = false;

    // Create a new CartProductData object
    CartProductData newProduct = CartProductData(
      productId: productId, // Now guaranteed to be non-null
      quantity: 1,
      name: product.name, // Include product name
      desc: product.desc, // Include product description
      price: product.price, // Include product price
      type: product.type
    );
    print("The Product which I get: $newProduct");

    // Check if the product already exists in the bag
    for (var bagProduct in bagProducts) {
      for (var cartProduct in bagProduct.carts) {
        if (cartProduct.productId == newProduct.productId) {
          // If it exists, increase the quantity
          cartProduct.quantity++;
          productExists = true;
          break;
        }
      }
    }

    // If the product does not exist, create a new BagProductData
    if (!productExists) {
      // Ensure quantity is non-null and not initialized with null value
      bagProducts.add(BagProductData(quantity: 1, carts: [newProduct]));
    }

    List<BagData> bags = List.from(LocalStorage.getBags());

    // print(
    //     'isExsit Bag  => : ${bags[bagIndex]?.bagProducts?[0]?.carts} and BagIndex => ${bagIndex}');

    bags[bagIndex] = bags[bagIndex].copyWith(bagProducts: bagProducts);
    LocalStorage.setBags(bags);

    // Log the updated bags to check if the product is added successfully
    rightSideNotifier.fetchCarts(
      checkYourNetwork: () {
        AppHelpers.showSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      },
    );
  }
}
