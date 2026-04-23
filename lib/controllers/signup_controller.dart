import 'package:flutter_mekitakizi/service/database_service.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role, //'customer' or 'driver'
    required String phone,  
  }) async {
    final response = await DatabaseService.register(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
    );
    return response;
  }
  Future login(String email, String password) async {
    final response = await DatabaseService.login(
      email: email,
      password: password,
    );
    return response['success'] == true;
  }
  }