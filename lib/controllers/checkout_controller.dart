import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_mekitakizi/core/constants/app_constants.dart';

class CheckoutController {
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required int restaurantId,
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required int deliveryFee,
    String? note,
  }) async {
    try {
      final items = cartItems.map((ci) => {
        'menu_item_id': ci.item.id,
        'quantity':     ci.quantity,
        'price':        ci.item.price.toInt(),
      }).toList();

      final subtotal   = cartItems.fold(0, (sum, ci) => sum + (ci.item.price * ci.quantity).toInt());
      final total      = subtotal + deliveryFee;

      final response = await http.post(
        Uri.parse('$baseUrl/place_order.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id':          userId,
          'restaurant_id':    restaurantId,
          'items':            items,
          'total':            total,
          'delivery_fee':     deliveryFee,
          'delivery_address': deliveryAddress,
          'note':             note ?? '',
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
