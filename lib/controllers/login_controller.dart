import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/auth/login_screen.dart';

class LoginController {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == "admin@gmail.com" && password == "123456") {
      return {"success": true};
    } else {
      return {
        "success": false,
        "message": "Invalid email or password"
      };
    }
  }

  void goToLoginScreen(BuildContext context, String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(role: role)),
    );
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      // ignore: prefer_const_constructors
      MaterialPageRoute(builder: (_) => LoginScreen(role: "customer")),
      (route) => false,
    );
  }
}