import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  // LOGIN
  Future<Either<Failure, User>> login(
      {required String email, required String password});

  // REQUEST REGISTER
  Future<Either<Failure, User>> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String rol,
  });

  // CHECKAUTH
  Future<Either<Failure, User>> checkAuth({required String token});
}
