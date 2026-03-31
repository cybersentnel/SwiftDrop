import 'dart:convert';
import 'package:http/http.dart' as http;

class ActiveDeliveryController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> confirmPickup({
    required int orderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_order_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id': orderId,
          'status':   'on_the_way',
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
  
  Future<Map<String, dynamic>> confirmDelivery({
    required int orderId,
    required int driverId,
    required int amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update_order_status.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id':  orderId,
          'driver_id': driverId,
          'status':    'delivered',
          'amount':    amount,
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
