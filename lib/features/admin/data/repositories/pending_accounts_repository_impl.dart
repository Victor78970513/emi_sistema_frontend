import 'package:dartz/dartz.dart';
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
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
