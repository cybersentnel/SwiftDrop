import 'dart:convert';
import 'package:http/http.dart' as http;

class EarningsController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> getEarnings({
    required int driverId,
    String period = 'today',
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_earnings.php?driver_id=$driverId&period=$period'),
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
  int calculateTotal(List<Map<String, dynamic>> earnings) {
    return earnings.fold(0, (sum, e) => sum + (e['amount'] as int));
  }

  int calculateTips(List<Map<String, dynamic>> earnings) {
    return earnings.fold(0, (sum, e) => sum + (e['tip'] as int));
  }
}
