import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    on<SendVerificationEmail>(_onSendVerificationEmail);
    on<CheckEmailVerification>(_onCheckEmailVerification);
  }

  Future<void> _onSendVerificationEmail(
      SendVerificationEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await event.user.sendEmailVerification();
      emit(AuthNotVerified());
    } catch (e) {
      emit(AuthError('Failed to send verification email. Please try again.'));
    }
  }

  Future<void> _onCheckEmailVerification(
      CheckEmailVerification event, Emitter<AuthState> emit) async {
    try {
      await _firebaseAuth.currentUser?.reload();
      final user = _firebaseAuth.currentUser;
      if (user != null && user.emailVerified) {
        emit(AuthVerified());
      } else {
        emit(AuthNotVerified());
      }
    } catch (e) {
      emit(AuthError('Error checking email verification status.'));
    }
  }
}
