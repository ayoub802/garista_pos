import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/notifications/riverpod/notification_notifier.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/notifications/riverpod/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
        (ref) => NotificationNotifier(notificationRepository));
