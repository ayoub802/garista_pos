import 'package:garista_pos/src/core/di/dependency_manager.dart';
import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:garista_pos/src/models/data/notification_data.dart';
import 'package:garista_pos/src/presentation/pages/main/widgets/notifications/riverpod/notification_state.dart';
import 'package:garista_pos/src/repository/notification_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../models/data/notification_transactions_data.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepository _notificationRepository;

  int _page = 0;
  int _notificationPage = 0;

  NotificationNotifier(this._notificationRepository)
      : super(const NotificationState());

  changeFirst() {
    state = state.copyWith(isFirstTimeNotification: true);
  }

  Future<void> fetchAllNotifications(BuildContext context) async {
    state = state.copyWith(isNotificationLoading: true);

    final response = await _notificationRepository.getAllNotifications();
    response.when(
      success: (data) {
        state = state.copyWith(
            isNotificationLoading: false, notifications: data.data ?? []);
      },
      failure: (failure) {
        AppHelpers.showSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> fetchNotificationsPaginate({
    VoidCallback? checkYourNetwork,
  }) async {
    if (!state.hasMoreNotification) {
      return;
    }
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (_notificationPage == 0) {
        state = state.copyWith(isNotificationLoading: true, notifications: []);

        final response = await notificationRepository.getNotifications(
          page: ++_notificationPage,
        );
        response.when(
          success: (data) {
            state = state.copyWith(
              notifications: data.data ?? [],
              isNotificationLoading: false,
            );
            if ((data.data?.length ?? 0) < 5) {
              state = state.copyWith(hasMoreNotification: false);
            }
          },
          failure: (failure) {
            state = state.copyWith(isNotificationLoading: false);
            debugPrint('==> get products failure: $failure');
          },
        );
      } else {
        state = state.copyWith(isMoreNotificationLoading: true);
        final response = await notificationRepository.getNotifications(
          page: ++_notificationPage,
        );
        response.when(
          success: (data) async {
            final List<NotificationModel> newList =
                List.from(state.notifications);
            newList.addAll(data.data ?? []);
            state = state.copyWith(
              notifications: newList,
              isMoreNotificationLoading: false,
            );
            if ((data.data?.length ?? 0) < 5) {
              state = state.copyWith(hasMoreNotification: false);
            }
          },
          failure: (failure) {
            state = state.copyWith(isMoreNotificationLoading: false);
            debugPrint('==> get notifications more failure: $failure');
          },
        );
      }
    } else {
      checkYourNetwork?.call();
    }
  }

  Future<void> readAll(BuildContext context) async {
    List<NotificationModel> notif = List.from(state.notifications);

    for (var i = 0; i < notif.length; i++) {
      if (notif[i].viewed == 0 || notif[i].viewed == null) {
        notif[i] = notif[i].copyWith(viewed: 1); // Mark as viewed (1 for true)
      }
    }

    state = state.copyWith(
      notifications: notif,
      countOfNotifications:
          state.countOfNotifications?.copyWith(notification: 0),
    );

    updateTotal();

    final response = await _notificationRepository.readAll();
    response.when(
      success: (data) {
        debugPrint('Marked all notifications as viewed successfully.');
      },
      failure: (failure) {
        AppHelpers.showSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> readOne(BuildContext context,
      {int? id, required int index}) async {
    List<NotificationModel> notif = List.from(state.notifications);

    notif[index] = notif[index].copyWith(viewed: 1);

    final notification = state.countOfNotifications?.copyWith(
      notification: (state.countOfNotifications?.notification ?? 0) - 1,
    );

    state = state.copyWith(
        notifications: notif, countOfNotifications: notification);

    updateTotal();

    final response = await _notificationRepository.readOne(id: id);
    response.when(
      success: (data) {
        debugPrint('Success read one');
      },
      failure: (failure) {
        AppHelpers.showSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> fetchCount(BuildContext context) async {
    final response = await _notificationRepository.getCount();
    response.when(
      success: (data) {
        print("The Count of Notification => ${data.notification}");
        state = state.copyWith(countOfNotifications: data);
        state = state.copyWith(totalCount: (data.notification ?? 0));

        debugPrint('Success count');
      },
      failure: (failure) {
        AppHelpers.showSnackBar(context, failure.toString());
      },
    );
  }

  updateTotal() {
    state = state.copyWith(
        totalCount: (state.countOfNotifications?.notification ?? 0));
  }
}
