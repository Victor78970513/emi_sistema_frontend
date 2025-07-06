import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';
import 'package:frontend_emi_sistema/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});
  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    // Validación local
    if (email.isEmpty || !email.contains('@')) {
      return left(ValidationFailure('Correo inválido'));
    }
    if (password.isEmpty) {
      return left(ValidationFailure('La contraseña no puede estar vacía'));
    }
    try {
      final loginResponse =
          await authRemoteDatasource.login(email: email, password: password);
      return right(loginResponse);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(AuthenticationFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error desconocido'));
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    required int rolId,
    required int carreraId,
  }) async {
    // Validación local
    if (nombres.isEmpty) {
      return left(ValidationFailure('El nombre no puede estar vacío'));
    }
    if (apellidos.isEmpty) {
      return left(ValidationFailure('El apellido no puede estar vacío'));
    }
    if (correo.isEmpty || !correo.contains('@')) {
      return left(ValidationFailure('Correo inválido'));
    }
    if (contrasena.isEmpty) {
      return left(ValidationFailure('La contraseña no puede estar vacía'));
    }
    if (carreraId == 0) {
      return left(ValidationFailure('Selecciona una carrera'));
    }
    try {
      final registerResponse = await authRemoteDatasource.register(
        nombres: nombres,
        apellidos: apellidos,
        correo: correo,
        contrasena: contrasena,
        rolId: rolId,
        carreraId: carreraId,
      );
      return right(registerResponse);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(AuthenticationFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error desconocido'));
    }
  }

  @override
  Future<Either<Failure, bool>> logOut() async {
    try {
      final response = await authRemoteDatasource.logOut();
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error desconocido'));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth({required String token}) async {
    try {
      final checkResponse = await authRemoteDatasource.checkAuth(token: token);
      return right(checkResponse);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(AuthenticationFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error desconocido'));
    }
  }
}
