import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';

class DatabaseService {
  static const String baseUrl = AppConstants.baseUrl;
  static const Duration timeout = Duration(seconds: 10);

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return _post("login.php", {
      "email": email,
      "password": password,
    });
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String role, 
    required String phone,
  }) async {
    return _post("register.php", {
      "email": email,
      "password": password,
      "name": name,
      "role": role,
      "phone": phone,
    });
  }

  static Future<Map<String, dynamic>> getRestaurants({
    String? category,
    int? id,
  }) async {
    final query = <String, String>{};
    if (category != null && category.isNotEmpty) query["category"] = category;
    if (id != null) query["id"] = id.toString();
    return _get("get_restaurants.php", query: query);
  }

  static Future<Map<String, dynamic>> getMenu({
    required int restaurantId,
  }) async {
    return _get("get_menu.php", query: {
      "restaurant_id": restaurantId.toString(),
    });
  }

  static Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required int restaurantId,
    required List<Map<String, dynamic>> items,
    required int total,
    required int deliveryFee,
    required String deliveryAddress,
    String note = "",
  }) async {
    return _post("place_order.php", {
      "user_id": userId,
      "restaurant_id": restaurantId,
      "items": items,
      "total": total,
      "delivery_fee": deliveryFee,
      "delivery_address": deliveryAddress,
      "note": note,
    });
  }

  static Future<Map<String, dynamic>> getOrders({
    required int userId,
  }) async {
    return _get("get_orders.php", query: {
      "user_id": userId.toString(),
    });
  }

  static Future<Map<String, dynamic>> getOrderDetails({
    required int orderId,
  }) async {
    return _get("get_order_details.php", query: {
      "order_id": orderId.toString(),
    });
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
    int? driverId,
    int? amount,
  }) async {
    return _post("update_order_status.php", {
      "order_id": orderId.toString(),
      "status": status,
      if (driverId != null) "driver_id": driverId.toString(),
      if (amount != null) "amount": amount.toString(),
    });
  }

  static Future<Map<String, dynamic>> getAvailableOrders() async {
    return _get("get_available_orders.php");
  }

  static Future<Map<String, dynamic>> acceptOrder({
    required int orderId,
    required int driverId,
  }) async {
    return _post("accept_order.php", {
      "order_id": orderId.toString(),
      "driver_id": driverId.toString(),
    });
  }

  static Future<Map<String, dynamic>> getEarnings({
    required int driverId,
    String period = "today",
  }) async {
    return _get("get_earnings.php", query: {
      "driver_id": driverId.toString(),
      "period": period,
    });
  }

  static Future<Map<String, dynamic>> _get(
      String endpoint, {
        Map<String, String>? query,
      }) async {
    final uri = Uri.parse("$baseUrl/$endpoint");
    final finalUri = (query == null || query.isEmpty)
        ? uri
        : uri.replace(queryParameters: query);
    final response = await http.get(finalUri).timeout(timeout);
    return _decode(response.body);
  }

  static Future<Map<String, dynamic>> _post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final uri = Uri.parse("$baseUrl/$endpoint");

    if (kDebugMode) debugPrint("POST $uri — ${jsonEncode(body)}");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
      ).timeout(Duration(seconds: 10));
    if (kDebugMode) debugPrint("RESPONSE: ${response.body}");
    return _decode(response.body);
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final data = jsonDecode(body);
      return data is Map<String, dynamic>
          ? data
          : {"success": false, "message": "Invalid response"};
    } catch (e) {
      return {"success": false, "message": "JSON error: $e"};
    }
  }
}