import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  // LOGIN
  Future<Either<Failure, User>> login(
      {required String email, required String password});

  // REQUEST REGISTER
  Future<Either<Failure, bool>> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    required int rolId,
    required int carreraId,
  });

  //LOGOUT
  Future<Either<Failure, bool>> logOut();

  // CHECKAUTH
  Future<Either<Failure, User>> checkAuth({required String token});
}
