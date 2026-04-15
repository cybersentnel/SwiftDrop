import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class DatabaseService {
  DatabaseService._();

  static const String _defaultBaseUrl = 'http://192.168.9.220/swiftdrop';
    
  static const Duration _timeout = Duration(seconds: 20);

  static Future<Map<String, dynamic>>register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    return _post(
      'register.php',
      {
        'email': email.trim(),
        'password': password.trim(),
        'name': name.trim(),
        'role': role.trim(),
      },
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    }) async {
    return _post(
      'login.php',
      {
        'email': email.trim(),
        'password': password.trim(),
      },
    );
  }

  

  static Future<Map<String, dynamic>> getRestaurants({
    String? category,
    int? id,
  }) {
    final query = <String, String>{};
    if (category != null && category.trim().isNotEmpty) {
      query['category'] = category.trim();
    }
    if (id != null) {
      query['id'] = id.toString();
    }
    return _get('get_restaurants.php', query: query);
  }

  static Future<Map<String, dynamic>> getMenu({
    required int restaurantId,
  }) {
    return _get(
      'get_menu.php',
      query: {'restaurant_id': restaurantId.toString()},
    );
  }

  static Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required int restaurantId,
    required List<Map<String, dynamic>> items,
    required int total,
    required int deliveryFee,
    required String deliveryAddress,
    String note = '',
  }) {
    return _post(
      'place_order.php',
      {
        'user_id': userId,
        'restaurant_id': restaurantId,
        'items': items,
        'total': total,
        'delivery_fee': deliveryFee,
        'delivery_address': deliveryAddress,
        'note': note,
      },
    );
  }

  static Future<Map<String, dynamic>> getOrders({
    required int userId,
  }) {
    return _get(
      'get_orders.php',
      query: {'user_id': userId.toString()},
    );
  }

  static Future<Map<String, dynamic>> getOrderDetails({
    required int orderId,
  }) {
    return _get(
      'get_order_details.php',
      query: {'order_id': orderId.toString()},
    );
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
    int? driverId,
    int? amount,
  }) {
    final body = <String, dynamic>{
      'order_id': orderId,
      'status': status,
    };

    if (driverId != null) {
      body['driver_id'] = driverId;
    }

    if (amount != null) {
      body['amount'] = amount;
    }

    return _post('update_order_status.php', body);
  }

  static Future<Map<String, dynamic>> getAvailableOrders() {
    return _get('get_available_orders.php');
  }

  static Future<Map<String, dynamic>> acceptOrder({
    required int orderId,
    required int driverId,
  }) {
    return _post(
      'accept_order.php',
      {
        'order_id': orderId,
        'driver_id': driverId,
      },
    );
  }

  static Future<Map<String, dynamic>> getEarnings({
    required int driverId,
    String period = 'today',
  }) {
    return _get(
      'get_earnings.php',
      query: {
        'driver_id': driverId.toString(),
        'period': period,
      },
    );
  }

  static Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, String>? query,
  }) async {
    try {
      final uri = _uri(endpoint, query: query);
      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);
      return _decodeResponse(response);
    } on TimeoutException {
      return _networkError('Request timed out. Check your connection.');
    } on SocketException {
      return _networkError(
        'Could not connect to server. Make sure your backend is running.',
      );
    } catch (e) {
      return _networkError('Unexpected network error: $e');
    }
  }

  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = _uri(endpoint);
      final response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _decodeResponse(response);
    } on TimeoutException {
      return _networkError('Request timed out. Check your connection.');
    } on SocketException {
      return _networkError(
        'Could not connect to server. Make sure your backend is running.',
      );
    } catch (e) {
      return _networkError('Unexpected network error: $e');
    }
  }

  static Uri _uri(String endpoint, {Map<String, String>? query}) {
    final base = Uri.parse(_defaultBaseUrl);
    final normalizedBasePath = base.path.endsWith('/')
        ? base.path.substring(0, base.path.length - 1)
        : base.path;
    final normalizedEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;

    return base.replace(
      path: '$normalizedBasePath/$normalizedEndpoint',
      queryParameters: (query == null || query.isEmpty) ? null : query,
    );
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.body.trim().isEmpty) {
      return {
        'success': false,
        'message': 'Server returned an empty response.',
      };
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      return {
        'success': false,
        'message': 'Invalid server response.',
        'status_code': response.statusCode,
      };
    }

    if (decoded is! Map<String, dynamic>) {
      return {
        'success': false,
        'message': 'Unexpected response format.',
        'status_code': response.statusCode,
      };
    }

    if (response.statusCode >= 400 && decoded['success'] != true) {
      return {
        ...decoded,
        'status_code': response.statusCode,
        'success': false,
      };
    }

    return decoded;
  }

  static Map<String, dynamic> _networkError(String message) {
    return {
      'success': false,
      'message': message,
    };
  }
}