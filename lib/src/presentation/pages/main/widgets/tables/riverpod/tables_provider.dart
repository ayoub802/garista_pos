
import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/riverpod/tables_notifier.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/tables/riverpod/tables_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tablesProvider = StateNotifierProvider<TablesNotifier, TablesState>(
  (ref) => TablesNotifier(tableRepository),

);
