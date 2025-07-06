import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/admin/data/models/pending_account_model.dart';

abstract interface class PendingAccountsDatasource {
  Future<List<PendingAccountModel>> getPendingAccounts();
  Future<bool> aprovePendingAccount({required int id});
}

class PendingAccountsDatasourceImpl implements PendingAccountsDatasource {
  final dio = Dio();
  @override
  Future<List<PendingAccountModel>> getPendingAccounts() async {
    try {
      print("PendingAccountsDatasource - Obteniendo cuentas pendientes");
      final response =
          await dio.get("http://localhost:3000/api/admin/users/pending");

      print(
          "PendingAccountsDatasource - Respuesta del backend: ${response.data}");

      final data = response.data as List<dynamic>;
      final pendingAccounts =
          data.map((account) => PendingAccountModel.fromJson(account)).toList();

      print(
          "PendingAccountsDatasource - Cuentas pendientes procesadas: ${pendingAccounts.length}");

      return pendingAccounts;
    } catch (e) {
      // ignore: avoid_print
      print("Error en getPendingAccounts: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al traer cuentas pendientes");
    }
  }

  @override
  Future<bool> aprovePendingAccount({required int id}) async {
    try {
      print("PendingAccountsDatasource - Aprobando cuenta con ID: $id");
      final response =
          await dio.put("http://localhost:3000/api/admin/users/$id/activate");

      print(
          "PendingAccountsDatasource - Respuesta de aprobación: ${response.data}");

      final data = response.data;
      final user = PendingAccountModel.fromJson(data);

      if (!user.isActive) {
        throw ServerException("Error al activar cuenta");
      }

      print("PendingAccountsDatasource - Cuenta aprobada exitosamente");
      return user.isActive;
    } catch (e) {
      // ignore: avoid_print
      print("Error en aprovePendingAccount: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al activar cuenta");
    }
  }
}
