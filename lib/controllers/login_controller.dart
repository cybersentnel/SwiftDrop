import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/controllers/role_select_controller.dart';
import 'package:flutter_mekitakizi/service/database_service.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPassVisible = false.obs;
  var isLoading = false.obs;

  void togglePassword() => isPassVisible.value = !isPassVisible.value;

  Future<Map<String, dynamic>> login({
    required String email, 
    required String password, 
    }) async {
  if (email.trim().isEmpty || password.trim().isEmpty) {

      Get.snackbar(
        "Missing Fields",
        "Please enter your email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return {
      "success": false,
      "message": "Please enter your email and password"};
    }
    if (password.length < 6) {
      Get.snackbar(
        "Weak Password",
        "Password must be at least 6 characters",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber[100],
        colorText: Colors.brown[800],
      );
      return {"success": false, "message": "Password must be at least 6 characters"};
    }

    isLoading.value = true;

    final response = await DatabaseService.login(
      email: email,
      password: password,
    );
    isLoading.value = false;

    if (response["success"] == true) {
      Get.find<RoleSelectController>().setUser(response["user"]);

      return {
        "success":true,
        "message": "Login successful",
      };
    } else {
      Get.snackbar(
        "Login Failed",
        response["message"],
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return {
        "success": false,
        "message": response["message"]
      };
    }
  }
}