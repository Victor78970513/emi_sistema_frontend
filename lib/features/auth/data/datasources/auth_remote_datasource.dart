import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  //
  Future<UserModel> login({required String email, required String password});
  //
  Future<UserModel> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String rol,
  });
  //
  Future<UserModel> checkAuth({required String token});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final dio = Dio();
  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        "http://localhost:3000/api/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      final user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e.toString());
      throw ServerException("Error en el Login");
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
    required String rol,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<UserModel> checkAuth({required String token}) async {
    try {
      final response = await dio.post(
        "http://localhost:3000/api/auth/checkAuth",
        data: {"token": token},
      );
      final user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      print(e.toString());
      throw ServerException(
        "Error en el CheckLogin",
      );
    }
  }
}
