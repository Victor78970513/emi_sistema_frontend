import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';
import 'package:frontend_emi_sistema/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});
  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    try {
      final loginResponse =
          await authRemoteDatasource.login(email: email, password: password);
      return right(loginResponse);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String rol,
  }) async {
    try {
      final registerResponse = await authRemoteDatasource.register(
        name: name,
        lastName: lastName,
        email: email,
        password: password,
        rol: rol,
      );
      return right(registerResponse);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth({required String token}) async {
    try {
      final checkResponse = await authRemoteDatasource.checkAuth(token: token);
      return right(checkResponse);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
