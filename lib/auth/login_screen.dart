import 'package:flutter/material.dart';
import 'package:flutter_mekitakizi/core/theme/theme.dart';
import 'package:flutter_mekitakizi/auth/signup_screen.dart';
import 'package:flutter_mekitakizi/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final LoginController _controller = LoginController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final result = await _controller.login(
      email: _emailCtrl.text,
      password: _passwordCtrl.text,
    ).timeout(const Duration(seconds: 10));

    if (!mounted) return;
    setState(() => _loading = false);

     if (result["success"] == true) {
      final route = '/${widget.role}/home';
      debugPrint("Navigating to: $route");

Navigator.pushReplacementNamed(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"] ?? 'Login failed'),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),        ),
      ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 32),

                Row(children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delivery_dining,
                        color: Colors.white, size: 26),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'SwiftDrop',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ]),
                SizedBox(height: 48),

                Text(
                  'Welcome back! 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.6,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue to your account.',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 15),
                ),
                SizedBox(height: 40),

                // Email
                const _FieldLabel('Email'),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.mail_outline,
                        size: 20, color: AppTheme.textSecondary),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 16),

                const _FieldLabel('Password'),
                SizedBox(height: 8),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline,
                        size: 20, color: AppTheme.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white),
                          )
                        : Text('Log In'),
                  ),
                ),
                SizedBox(height: 24),

                // ignore: prefer_const_literals_to_create_immutables
                Row(children: [
                  Expanded(child: Divider(color: AppTheme.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider(color: AppTheme.border)),
                ]),
                SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SignupScreen(role: widget.role)),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
}