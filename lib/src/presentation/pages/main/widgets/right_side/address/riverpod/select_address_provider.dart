import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select_address_state.dart';
import 'select_address_notifier.dart';

final selectAddressProvider =
    StateNotifierProvider<SelectAddressNotifier, SelectAddressState>(
  (ref) => SelectAddressNotifier(usersRepository),
);
