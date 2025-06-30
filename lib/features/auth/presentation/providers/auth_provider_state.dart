import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
