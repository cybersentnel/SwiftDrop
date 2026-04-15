import 'package:flutter_mekitakizi/service/database_service.dart';

class ActiveDeliveryController {
  Future<Map<String, dynamic>> confirmPickup({
    required int orderId,
  }) async {
    return DatabaseService.updateOrderStatus(
      orderId: orderId,
      status: 'on_the_way',
    );
  }
  
  Future<Map<String, dynamic>> confirmDelivery({
    required int orderId,
    required int driverId,
    required int amount,
  }) async {
    return DatabaseService.updateOrderStatus(
      orderId: orderId,
      driverId: driverId,
      status: 'delivered',
      amount: amount,
    );
  }
}
