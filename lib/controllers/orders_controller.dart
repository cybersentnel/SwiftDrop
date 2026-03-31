import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> getOrders({
    required int userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_orders.php?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to server. Make sure XAMPP is running.',
      };
    }
  }

  Future<Map<String, dynamic>> getOrderDetails({
    required int orderId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_order_details.php?order_id=$orderId'),
        headers: {'Content-Type': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to server. Make sure XAMPP is running.',
      };
    }
  }

  Future<Map<String, dynamic>> updateStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_order_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id': orderId,
          'status':   status,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to server. Make sure XAMPP is running.',
      };
    }
  }
}
