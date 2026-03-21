import 'package:get/get.dart';

class LoginController extends GetxController {
  // ignore: prefer_typing_uninitialized_variables
  var username;
  // ignore: prefer_typing_uninitialized_variables
  var password;
  var isPassVisible = false.obs;

  bool login(String user, String pass) {
    username = user;
    password = pass;
    if (username == "admin" && password == "12345") {
      return true;
    } else {
      return false;
    }
  }

  togglePassword() {
    isPassVisible.value = !isPassVisible.value;
  }
}