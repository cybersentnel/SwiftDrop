import 'package:flutter_mekitakizi/core/constants/app_constants.dart';
import 'package:flutter_mekitakizi/service/database_service.dart';

class CheckoutController {
  Future<Map<String, dynamic>> placeOrder({
    required int userId,
    required int restaurantId,
    required List<CartItem> cartItems,
    required String deliveryAddress,
    required int deliveryFee,
    String? note,
  }) async {
    final items = cartItems.map((ci) => {
        'menu_item_id': ci.item.id,
        'quantity':     ci.quantity,
        'price':        ci.item.price.toInt(),
      }).toList();

    final subtotal = cartItems.fold(
      0,
      (sum, ci) => sum + (ci.item.price * ci.quantity).toInt(),
    );
    final total = subtotal + deliveryFee;

    return DatabaseService.placeOrder(
      userId: userId,
      restaurantId: restaurantId,
      items: items,
      total: total,
      deliveryFee: deliveryFee,
      deliveryAddress: deliveryAddress,
      note: note ?? '',
    );
  }
}
