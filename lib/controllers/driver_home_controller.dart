import 'package:flutter_mekitakizi/service/database_service.dart';

class DriverHomeController {
  Future<Map<String, dynamic>> getAvailableOrders() async {
    return DatabaseService.getAvailableOrders();
  }

  Future<Map<String, dynamic>> acceptOrder({
    required int orderId,
    required int driverId,
  }) async {
    return DatabaseService.acceptOrder(
      orderId: orderId,
      driverId: driverId,
    );
  }

  void declineOrder(int orderId) {
  }
}
