import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/admin/data/models/pending_account_model.dart';

abstract interface class PendingAccountsDatasource {
  Future<List<PendingAccountModel>> getPendingAccounts();
  Future<bool> aprovePendingAccount({required int id});
  Future<bool> rejectPendingAccount({required int id, required String reason});
}

class PendingAccountsDatasourceImpl implements PendingAccountsDatasource {
  final dio = Dio();
  @override
  Future<List<PendingAccountModel>> getPendingAccounts() async {
    try {
      print("PendingAccountsDatasource - Obteniendo cuentas pendientes");
      final response = await dio.get(
        // "http://localhost:3000/api/admin/users/pending",
        "${Constants.baseUrl}api/admin/users/pending",
      );

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
      final response = await dio.put(
        // "http://localhost:3000/api/admin/users/$id/approve",
        "${Constants.baseUrl}api/admin/users/$id/approve",
      );

      print(
          "PendingAccountsDatasource - Respuesta de aprobación: ${response.data}");

      final data = response.data;

      // Verificar que el estado_id sea 1 (activo)
      final estadoId = int.tryParse(data["estado_id"] ?? "0") ?? 0;
      if (estadoId != 1) {
        throw ServerException("Error al activar cuenta");
      }

      print("PendingAccountsDatasource - Cuenta aprobada exitosamente");
      return true;
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

  @override
  Future<bool> rejectPendingAccount(
      {required int id, required String reason}) async {
    try {
      print(
          "PendingAccountsDatasource - Rechazando cuenta con ID: $id, razón: $reason");
      final response = await dio.put(
        // "http://localhost:3000/api/admin/users/$id/reject",
        "${Constants.baseUrl}api/admin/users/$id/reject",
        data: {
          "reason": reason,
        },
      );

      print(
          "PendingAccountsDatasource - Respuesta de rechazo: ${response.data}");

      final data = response.data;

      // Verificar que el estado_id sea 2 (rechazado)
      final estadoId = int.tryParse(data["estado_id"] ?? "0") ?? 0;
      if (estadoId != 2) {
        throw ServerException("Error al rechazar cuenta");
      }

      print("PendingAccountsDatasource - Cuenta rechazada exitosamente");
      return true;
    } catch (e) {
      // ignore: avoid_print
      print("Error en rejectPendingAccount: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al rechazar cuenta");
    }
  }
}
