import 'dart:async';

import 'package:garista_pos/src/core/constants/constants.dart';
import 'package:garista_pos/src/core/utils/app_helpers.dart';
import 'package:garista_pos/src/models/data/order_data.dart';
import 'package:garista_pos/src/repository/orders_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'on_a_way_orders_state.dart';

class OnAWayOrdersNotifier extends StateNotifier<OnAWayOrdersState> {
  final OrdersRepository _ordersRepository;
  int _page = 0;
  Timer? _searchProductsTimer;
  Timer? _refreshTime;

  OnAWayOrdersNotifier(this._ordersRepository)
      : super(const OnAWayOrdersState());

  void setOrdersQuery(BuildContext context, String query) {
    if (state.query == query) {
      return;
    }
    state = state.copyWith(query: query.trim());
    if (state.query.isNotEmpty) {
      if (_searchProductsTimer?.isActive ?? false) {
        _searchProductsTimer?.cancel();
      }
      _searchProductsTimer = Timer(
        const Duration(milliseconds: 500),
        () {
          state = state.copyWith(hasMore: true, orders: []);
          _page = 0;
          fetchOnAWayOrders(
            checkYourNetwork: () {
              AppHelpers.showSnackBar(
                context,
                AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
              );
            },
          );
        },
      );
    } else {
      if (_searchProductsTimer?.isActive ?? false) {
        _searchProductsTimer?.cancel();
      }
      _searchProductsTimer = Timer(
        const Duration(milliseconds: 500),
        () {
          state = state.copyWith(hasMore: true, orders: []);
          _page = 0;
          fetchOnAWayOrders(checkYourNetwork: () {
            AppHelpers.showSnackBar(
              context,
              AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
            );
          });
        },
      );
    }
  }

  Future<void> fetchOnAWayOrders({
    VoidCallback? checkYourNetwork,
    bool isRefresh = false,
    Function(int)? updateTotal,
    DateTime? start,
    DateTime? end,
    String? searchText,
  }) async {
    if (isRefresh) {
      _page = 0;
      state = state.copyWith(hasMore: true,orders: []);
      _refreshTime?.cancel();
    }
    if (!state.hasMore) {
      return;
    }
    state = state.copyWith(isLoading: true);
    final response = await _ordersRepository.getOrders(
      status: OrderStatus.onAWay,
      page: ++_page,
      to: end,
      from: start,
      search: state.query.isEmpty ? null : state.query,
    );
    response.when(
      success: (data) {
        List<OrderData> orders =
            isRefresh || state.query.isNotEmpty ? [] : List.from(state.orders);
        final List<OrderData> newOrders = data?.orders ?? [];
        for (OrderData element in newOrders) {
          if (!orders.map((item) => item.id).contains(element.id)) {
            orders.add(element);
          }
        }
        state = state.copyWith(hasMore: newOrders.length >= (end == null ? 7 : 15));
        if (_page == 1 && !isRefresh) {
          state = state.copyWith(
            isLoading: false,
            orders: orders,
            totalCount: 0,
          );
          updateTotal?.call(0);
        } else {
          state = state.copyWith(
            isLoading: false,
            orders: orders,
            totalCount: 0,
          );
          updateTotal?.call(0);
        }
        if (isRefresh) {
          _refreshTime = Timer.periodic(AppConstants.refreshTime, (s) async {
            final response = await _ordersRepository.getOrders(
              status: OrderStatus.onAWay,
              page: 1,
              search: state.query.isEmpty ? null : state.query,
              to: end,
              from: start,
            );
            response.when(
                success: (data) {
                  // List<OrderData> orders = List.from(state.orders);
                  // for (OrderData element in data?.orders ?? []) {
                  //   if (!orders.map((item) => item.id).contains(element.id)) {
                  //     orders.insert(0, element);
                  //   }
                  // }
                  state = state.copyWith(orders: data?.orders??[],totalCount: 0);
                  updateTotal?.call(0);
                },
                failure: (f) {});
          });
        }
      },
      failure: (failure) {
        _page--;

        state = state.copyWith(isLoading: false);
      },
    );
  }

  addList(OrderData orderData, BuildContext context) async {
    List<OrderData> list = List.from(state.orders);
    list.insert(0, orderData);
    state = state.copyWith(orders: list, totalCount: state.totalCount + 1);
    final response = await _ordersRepository.updateOrderStatus(
      status: OrderStatus.onAWay,
      orderId: orderData.id,
    );
    response.when(
      success: (data) {
        AppHelpers.showSnackBar(context,
            "#${orderData.id} ${AppHelpers.getTranslation(TrKeys.orderStatusChanged)}",
            isIcon: true);
      },
      failure: (failure) {
        debugPrint('===> update order status fail $failure');
        AppHelpers.showSnackBar(context,
            AppHelpers.getTranslation(TrKeys.somethingWentWrongWithTheServer));
      },
    );
  }

  removeList(int index) {
    List<OrderData> list = List.from(state.orders);
    list.removeAt(index);
    state = state.copyWith(orders: list, totalCount: state.totalCount - 1);
  }

  deleteOrder(
    BuildContext context, {
    required orderId,
  }) async {
    removeList(getIndex(orderId));
    final response = await _ordersRepository.deleteOrder(
      orderId: orderId,
    );
    response.when(
      success: (data) {
        AppHelpers.showSnackBar(
            context, "#$orderId ${AppHelpers.getTranslation(TrKeys.deleted)}",
            isIcon: true);
      },
      failure: (failure) {
        debugPrint('===> delete order fail $failure');
        AppHelpers.showSnackBar(context,
            AppHelpers.getTranslation(TrKeys.somethingWentWrongWithTheServer));
      },
    );
  }

  int getIndex(id) {
    List<OrderData> list = List.from(state.orders);
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == id) {
        return i;
      }
    }
    return 0;
  }

  void stopTimer(){
    _refreshTime?.cancel();
  }
}