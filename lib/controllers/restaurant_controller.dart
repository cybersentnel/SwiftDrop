import 'dart:convert';
import 'package:http/http.dart' as http;

class RestaurantController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  // Get one restaurant by ID
  Future<Map<String, dynamic>> getRestaurantById({
    required int restaurantId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_restaurants.php?id=$restaurantId'),
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
  Future<Map<String, dynamic>> getMenu({
    required int restaurantId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_menu.php?restaurant_id=$restaurantId'),
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
