import 'dart:convert';
import 'package:http/http.dart' as http;

class DriverHomeController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> getAvailableOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_available_orders.php'),
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

  Future<Map<String, dynamic>> acceptOrder({
    required int orderId,
    required int driverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accept_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id':  orderId,
          'driver_id': driverId,
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

  void declineOrder(int orderId) {
  }
}
