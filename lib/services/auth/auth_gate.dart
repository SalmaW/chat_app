import 'package:chat_app/views/pages/verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../views/pages/home_page.dart';
import 'auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // Check if user logged in or not
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final user = snapshot.data!;
              // Check if email is verified
              if (user.emailVerified) {
                return HomePage(user: user);
              } else {
                return VerificationPage(user: user);
              }
            } else {
              return const Auth();
            }
          }),
    );
  }
}
