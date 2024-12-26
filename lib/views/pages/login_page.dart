import 'package:chat_app/views/widgets/my_elevated_button.dart';
import 'package:chat_app/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.message,
                size: 60,
                color: theme.primary,
              ),
              const SizedBox(height: 50),
              Text(
                "Welcome back, you've been missed",
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                hintText: "Email",
                controller: _emailController,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Password",
                controller: _passController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyElevatedButton(
                text: 'Login',
                onPressed: () => login(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?', style: TextStyle(color: theme.primary)),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      ' Register now',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: theme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
