import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/admin/data/models/pending_account_model.dart';

abstract interface class PendingAccountsDatasource {
  Future<List<PendingAccountModel>> getPendingAccounts();
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
}
