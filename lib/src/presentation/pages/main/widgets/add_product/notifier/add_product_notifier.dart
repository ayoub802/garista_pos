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

  void updateIngredient(BuildContext context, int selectIndex) {
    // Get the current list of ingredients from the product
    List<IngredientData>? ingredients = state.product?.ingredients;

    if (ingredients != null && ingredients.isNotEmpty) {
      // Toggle the active status of the selected ingredient
      ingredients[selectIndex].active =
          !(ingredients[selectIndex].active ?? false);

      // Update the product with the modified ingredients
      ProductData? updatedProduct =
          state.product?.copyWith(ingredients: ingredients);

      // Update the state with the modified product
      state = state.copyWith(product: updatedProduct);

      // Print the active status for debugging
      print(
          "Updated ingredient at index $selectIndex, active: ${ingredients[selectIndex].active}");
    }
  }

  // void removeIngredient(BuildContext context, int selectIndex) {
  //   if ((state.selectedStock?.addons?[selectIndex].product?.minQty ?? 0) <
  //       (state.selectedStock?.addons?[selectIndex].quantity ?? 0)) {
  //     List<Addons>? data = state.selectedStock?.addons;
  //     data?[selectIndex].quantity = (data[selectIndex].quantity ?? 0) - 1;
  //     List<Stocks>? stocks = state.product?.stocks;
  //     Stocks? newStock = stocks?.first.copyWith(addons: data);
  //     ProductData? product = state.product;
  //     ProductData? newProduct = product?.copyWith(stocks: [newStock!]);
  //     state = state.copyWith(product: newProduct);
  //   } else {
  //     AppHelpers.showSnackBar(
  //         context, AppHelpers.getTranslation(TrKeys.minQty));
  //   }
  // }

  void addProductToBag(
    BuildContext context,
    int bagIndex,
    RightSideNotifier rightSideNotifier,
    int quantity,
    double price,
    ProductData? product, // The product can be null
    List<Map<String, dynamic>> selectedToppings,
    List<Map<String, dynamic>> selectedVariants,
    List<Map<String, dynamic>> selectedIngredients,
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

    print("Mapped Selected Data: $selectedVariants");
    var toppingDataList = selectedToppings.map((topping) {
      return ToppingData(
        name: topping['name'],
        id: topping['id'],
        options: topping['options'].map<ToppingOptionData>((option) {
          return ToppingOptionData(
            name: option['name'],
            price: option['price'],
            isSelected: true, // Assuming these options are selected
          );
        }).toList(),
      );
    }).toList();

    var extraVriantsList = selectedVariants.map((topping) {
      return VariantData(
        name: topping['name'],
        id: topping['id'],
        options: topping['options'].map<VariantOptionData>((option) {
          return VariantOptionData(
            name: option['name'],
            price: option['price'],
            isSelected: true, // Assuming these options are selected
          );
        }).toList(),
      );
    }).toList();

    var ingredientsList = selectedIngredients.map((topping) {
      return IngredientData(
        name: topping['name'],
      );
    }).toList();

    List<Map<String, dynamic>> jsonVariantData =
        extraVriantsList.map((variant) => variant.toJson()).toList();
    print("Mapped Variant Data: $jsonVariantData");

    bool productExists = false;

    // Create a new CartProductData object
    CartProductData newProduct = CartProductData(
      productId: productId, // Now guaranteed to be non-null
      quantity: quantity,
      name: product.name, // Include product name
      desc: product.desc, // Include product description
      price: price, // Include product price
      type: product.type,
      selectedToppings: toppingDataList, // Convert to ToppingData
      selectedVariants: extraVriantsList, // Convert to ToppingData
      selectedIngrediants: ingredientsList, // Convert to ToppingData
    );
    print("The Product which I get: $newProduct");

    // Check if the product already exists in the bag
    for (var bagProduct in bagProducts) {
      for (var cartProduct in bagProduct.carts) {
        if (cartProduct.productId == newProduct.productId) {
          // If it exists, increase the quantity
          cartProduct.quantity++;
          cartProduct.price = newProduct.price;
          cartProduct.selectedToppings = newProduct.selectedToppings;
          cartProduct.selectedVariants = newProduct.selectedVariants;
          cartProduct.selectedIngrediants = newProduct.selectedIngrediants;
          productExists = true;
          break;
        }
      }
    }

    // If the product does not exist, create a new BagProductData
    if (!productExists) {
      // Ensure quantity is non-null and not initialized with null value
      bagProducts.add(BagProductData(quantity: quantity, carts: [newProduct]));
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
    Navigator.pop(context);
  }
}
