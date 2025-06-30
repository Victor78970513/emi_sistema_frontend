import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';

abstract class PendingAccountsState {}

final class PendingAccountsInitialState extends PendingAccountsState {}

final class PendingAccountsLoadingState extends PendingAccountsState {}

final class PendingAccountsSuccessState extends PendingAccountsState {
  final List<PendingAccount> pendingAccounts;

  PendingAccountsSuccessState({
    required this.pendingAccounts,
  });
}

final class PendingAccountsErrorState extends PendingAccountsState {
  final String message;

  PendingAccountsErrorState(this.message);
}
