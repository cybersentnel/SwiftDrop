import 'package:flutter_mekitakizi/views/home_screen.dart';
import 'package:flutter_mekitakizi/auth/login_screen.dart';
import 'package:flutter_mekitakizi/auth/signup_screen.dart';
import 'package:get/get.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen(role: '')),
  GetPage(name: "/signup", page: () => SignupScreen(role: 'role')),

  GetPage(name: "/user/home", page: () => HomeScreen()),
  GetPage(name: "/driver/home", page: () => HomeScreen()),
];