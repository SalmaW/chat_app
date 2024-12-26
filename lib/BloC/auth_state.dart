abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNotVerified extends AuthState {}

class AuthVerified extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
