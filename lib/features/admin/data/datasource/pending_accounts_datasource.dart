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
      final response =
          await dio.get("http://localhost:3000/api/admin/users/pending");
      final data = response.data as List<dynamic>;
      final pendingAccounts =
          data.map((account) => PendingAccountModel.fromJson(account)).toList();
      return pendingAccounts;
    } catch (e) {
      print(e.toString());
      throw ServerException("Error al traer cuentas pendientes");
    }
  }

  @override
  Future<bool> aprovePendingAccount({required int id}) async {
    try {
      final response =
          await dio.put("http://localhost:3000/api/admin/users/$id/activate");
      final data = response.data;
      print(data.toString());
      final user = PendingAccountModel.fromJson(data);
      if (!user.isActive) {
        throw ServerException("Error al activar cuenta");
      }
      return user.isActive;
    } catch (e) {
      print(e.toString());
      throw ServerException("Error al activar cuenta");
    }
  }
}
