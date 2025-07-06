import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/admin/data/datasource/pending_accounts_datasource.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';
import 'package:frontend_emi_sistema/features/admin/domain/repositories/pending_accounts_repository.dart';

class PendingAccountsRepositoryImpl implements PendingAccountsRepository {
  final PendingAccountsDatasource pendingAccountsDatasource;

  PendingAccountsRepositoryImpl({required this.pendingAccountsDatasource});
  @override
  Future<Either<Failure, List<PendingAccount>>> getPedingAccounts() async {
    try {
      final response = await pendingAccountsDatasource.getPendingAccounts();
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> aprovePendingAccount({required int id}) async {
    try {
      final response =
          await pendingAccountsDatasource.aprovePendingAccount(id: id);
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectPendingAccount(
      {required int id, required String reason}) async {
    try {
      final response = await pendingAccountsDatasource.rejectPendingAccount(
          id: id, reason: reason);
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
