import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDatasource {
  //
  Future<UserModel> login({required String email, required String password});
  //
  Future<bool> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    required int rolId,
    required int carreraId,
  });
  //
  Future<UserModel> checkAuth({required String token});
  //
  Future<bool> logOut();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final dio = Dio();
  @override
  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post(
        // "http://localhost:3000/api/auth/login",
        "${Constants.baseUrl}api/auth/login",
        data: {
          "correo": email,
          "contraseña": password,
        },
      );

      print("Respuesta del backend: ${response.data}");

      final user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      // ignore: avoid_print
      print("Error en login: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
        if (e.response?.data != null) {
          final errorMessage =
              e.response?.data['message'] ?? 'Error al iniciar sesión';
          throw ServerException(errorMessage);
        }
      }
      throw ServerException("Error al iniciar sesión");
    }
  }

  @override
  Future<bool> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    required int rolId,
    required int carreraId,
  }) async {
    try {
      final response = await dio.post(
        // "http://localhost:3000/api/auth/register",
        "${Constants.baseUrl}api/auth/register",
        data: {
          "nombres": nombres,
          "apellidos": apellidos,
          "correo": correo,
          "contraseña": contrasena,
          "rol_id": rolId,
          "carrera_id": carreraId,
        },
      );
      if (response.data is Map &&
          (response.data['token'] ?? '').toString().isNotEmpty) {
        return true;
      }
      throw ServerException("Error al mandar el registro");
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      throw ServerException("Error al mandar el registro");
    }
  }

  @override
  Future<UserModel> checkAuth({required String token}) async {
    print("checkAuth - Iniciando verificación con token: $token");
    try {
      final response = await dio.post(
        // "http://localhost:3000/api/auth/checkAuth",
        "${Constants.baseUrl}api/auth/checkAuth",
        data: {"token": token},
      );

      print("Respuesta del checkAuth: ${response.data}");

      final user = UserModel.fromJson(response.data);
      print("checkAuth - Usuario verificado: ${user.name} ${user.lastName}");
      return user;
    } catch (e) {
      // ignore: avoid_print
      print("Error en checkAuth: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException(
        "",
      );
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      final prefs = Preferences();
      await prefs.clear();
      print("Logout - Preferencias limpiadas");

      // Verificar que se limpiaron correctamente
      if (prefs.userToken.isEmpty) {
        print("Logout - Token eliminado correctamente");
        return true;
      } else {
        print("Logout - Error: Token no se eliminó");
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error en logout: ${e.toString()}");
      throw ServerException(
        "Error al cerrar sesión",
      );
    }
  }
}
