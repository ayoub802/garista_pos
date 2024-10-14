import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cooking_orders_state.dart';
import 'cooking_orders_notifier.dart';

final cookingOrdersProvider =
    StateNotifierProvider<CookingOrdersNotifier, CookingOrdersState>(
  (ref) => CookingOrdersNotifier(ordersRepository),
);
