import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginController {
  // Emulator:   http://10.0.2.2/swiftdrop
  // Real phone: http://YOUR_PC_IP/swiftdrop
  static const String baseUrl = 'http://10.0.2.2/swiftdrop';

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email':    email.trim(),
          'password': password.trim(),
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Could not connect to server. Make sure XAMPP is running.',
      };
    }
  }
}
