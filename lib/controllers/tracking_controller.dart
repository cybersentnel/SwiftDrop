import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackingController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> getOrderStatus({
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

  String getStatusLabel(int index) {
    switch (index) {
      case 0:  return 'placed';
      case 1:  return 'preparing';
      case 2:  return 'on_the_way';
      case 3:  return 'delivered';
      default: return 'placed';
    }
  }

  int getStatusIndex(String status) {
    switch (status) {
      case 'placed':      return 0;
      case 'preparing':   return 1;
      case 'on_the_way':  return 2;
      case 'delivered':   return 3;
      default:            return 0;
    }
  }
}
