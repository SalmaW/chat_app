import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class SendVerificationEmail extends AuthEvent {
  final User user;

  SendVerificationEmail(this.user);
}

class CheckEmailVerification extends AuthEvent {}
