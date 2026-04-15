import 'package:flutter_mekitakizi/service/database_service.dart';

class TrackingController {
  Future<Map<String, dynamic>> getOrderStatus({
    required int orderId,
  }) async {
    return DatabaseService.getOrderDetails(orderId: orderId);
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
