import 'package:flutter_mekitakizi/service/database_service.dart';

class RestaurantController {
  Future<Map<String, dynamic>> getRestaurantById({
    required int restaurantId,
  }) async {
    return DatabaseService.getRestaurants(id: restaurantId);
  }

  Future<Map<String, dynamic>> getMenu({
    required int restaurantId,
  }) async {
    return DatabaseService.getMenu(restaurantId: restaurantId);
  }
}
