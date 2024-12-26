import 'package:flutter/material.dart';

import '../../services/auth/auth_service.dart';
import '../widgets/my_elevated_button.dart';
import '../widgets/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  void register(BuildContext context) {
    final authService = AuthService();
    if (_passController.text == _confirmPassController.text) {
      try {
        authService.createUserWithEmailAndPassword(
            _emailController.text, _passController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text("Password don't match!"),
                content:
                    Text("Please make sure to write your password correctly."),
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
                "Let's create an account for you",
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
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Confirm Password",
                controller: _confirmPassController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              MyElevatedButton(
                text: 'Register',
                onPressed: () => register(context),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                      style: TextStyle(color: theme.primary)),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      ' Login now',
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
