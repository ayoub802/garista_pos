import 'dart:math';

import 'package:garista_pos/src/core/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:garista_pos/src/core/di/dependency_manager.dart';
import '../../core/handlers/handlers.dart';
import '../../models/models.dart';
import '../repository.dart';
import '../../core/constants/constants.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final data = {'login': email, 'password': password};
    try {
      final client = dioHttp.client(
          requireAuth: false, baseUrl: SecretVars.GaristabaseUrl);
      final response = await client.post(
        '/api/auth/login',
        queryParameters: data,
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.user != null) {
        final userId = loginResponse.user!.id;

        // Fetch restaurant by User ID and save it to local storage
        final restaurantResult = await fetchRestaurantByUserId(userId);

        // Handle success or failure in fetching restaurant
        if (restaurantResult.status == true) {
          // Save restaurant data to local storage
          await LocalStorage.setRestaurant(restaurantResult.restaurant!);
        } else {
          debugPrint('Failed to fetch restaurant: ${restaurantResult.message}');
        }
      }
      return ApiResult.success(
        data: LoginResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResult.failure(error: AppHelpers.errorHandler(e));
    }
  }

  @override
  Future<RestaurantResponse> fetchRestaurantByUserId(int? userId) async {
    try {
      final client = dioHttp.client(
        requireAuth: true,
        baseUrl: SecretVars.GaristabaseUrl,
      );
      final response = await client.get('/api/getResto/$userId');

      // Check if the response is a list or single restaurant
      if (response.data is List) {
        // If it's a list, let's map it to a list of Restaurant objects
        final List<dynamic> restaurantList = response.data;
        final List<Restaurant> restaurants =
            restaurantList.map((data) => Restaurant.fromJson(data)).toList();

        // For this example, let's just return the first restaurant
        // You can modify this logic based on your requirements
        if (restaurants.isNotEmpty) {
          return RestaurantResponse(
              status: true, restaurant: restaurants.first);
        } else {
          return RestaurantResponse(
              status: false, message: 'No restaurants found');
        }
      } else if (response.data is Map) {
        // If the response is a single restaurant, parse it directly
        final restaurant = Restaurant.fromJson(response.data);
        return RestaurantResponse(status: true, restaurant: restaurant);
      }

      return RestaurantResponse(
          status: false, message: 'Unexpected response format');
    } catch (e) {
      debugPrint('==> Fetch restaurant failure: $e');
      return RestaurantResponse(
          status: false, message: AppHelpers.errorHandler(e));
    }
  }

  // Future<ApiResult<void>> updateFirebaseToken(String? token) async {
  //   final data = {if (token != null) 'firebase_token': token};
  //   try {
  //     final client = dioHttp.client(requireAuth: true);
  //     await client.post(
  //       '/api/v1/dashboard/user/profile/firebase/token/update',
  //       data: data,
  //     );
  //     return const ApiResult.success(data: null);
  //   } catch (e) {
  //     debugPrint('==> update firebase token failure: $e');
  //     return ApiResult.failure(
  //       error: AppHelpers.errorHandler(e),
  //     );
  //   }
  // }
}
