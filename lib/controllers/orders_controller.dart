import 'package:flutter_mekitakizi/service/database_service.dart';

class OrdersController {
  Future<Map<String, dynamic>> getOrders({
    required int userId,
  }) async {
    return DatabaseService.getOrders(userId: userId);
  }

  Future<Map<String, dynamic>> getOrderDetails({
    required int orderId,
  }) async {
    return DatabaseService.getOrderDetails(orderId: orderId);
  }

  Future<Map<String, dynamic>> updateStatus({
    required int orderId,
    required String status,
  }) async {
    return DatabaseService.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }
}
