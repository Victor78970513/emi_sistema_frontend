import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

abstract class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  final User user;
  const AuthSuccess(this.user);
}

final class AuthRegistered extends AuthState {
  final bool registered;

  AuthRegistered(this.registered);
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
