import 'dart:async';
import 'package:chat_app/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../widgets/my_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationPage extends StatefulWidget {
  final User user;

  const VerificationPage({super.key, required this.user});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final authService = AuthService();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    authService.sendVerificationLink();
    timer = Timer(const Duration(seconds: 5), () {
      widget.user.reload().then((_) {
        if (widget.user.emailVerified == true) {
          timer.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(
              builder: (context) => HomePage(user: widget.user,)));
        }
      });
    });
  }

  void verify(BuildContext context) async {
    try {
      await authService.sendVerificationLink();
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme
        .of(context)
        .colorScheme;
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
                "We have sent a verification link to your Email. Please check your Email inbox",
                style: TextStyle(
                  color: theme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 25),
              MyElevatedButton(
                text: 'Resend Email',
                onPressed: () => authService.sendVerificationLink(),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       if (widget.user.emailVerified == true) {
              //         timer.cancel();
              //         Navigator.pushReplacement(context,
              //             MaterialPageRoute(builder: (context) => HomePage()));
              //       }
              //     },
              //     child: Text("go HOme"))
            ],
          ),
        ),
      ),
    );
  }
}
