import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';

abstract class PendingAccountsRepository {
  Future<Either<Failure, List<PendingAccount>>> getPedingAccounts();

  Future<Either<Failure, bool>> aprovePendingAccount({required int id});

  Future<Either<Failure, bool>> rejectPendingAccount(
      {required int id, required String reason});
}
