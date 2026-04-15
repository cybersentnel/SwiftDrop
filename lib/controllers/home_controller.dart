import 'package:flutter_mekitakizi/service/database_service.dart';

class HomeController {
  Future<Map<String, dynamic>> getRestaurants() async {
    return DatabaseService.getRestaurants();
  }

  Future<Map<String, dynamic>> getRestaurantsByCategory({
    required String category,
  }) async {
    return DatabaseService.getRestaurants(category: category);
  }
}