import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  // Get all restaurants
  Future<Map<String, dynamic>> getRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_restaurants.php'),
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

  Future<Map<String, dynamic>> getRestaurantsByCategory({
    required String category,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_restaurants.php?category=$category'),
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
}
