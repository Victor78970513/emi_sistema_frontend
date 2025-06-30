import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/domain/repositories/pending_accounts_repository.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_repository_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_state.dart';

class PendingAccountsNotifier extends StateNotifier<PendingAccountsState> {
  final PendingAccountsRepository _pendingAccountsRepository;
  PendingAccountsNotifier(this._pendingAccountsRepository)
      : super(PendingAccountsInitialState());

  Future<void> getPendingAccounts() async {
    state = PendingAccountsLoadingState();
    final response = await _pendingAccountsRepository.getPedingAccounts();
    response.fold(
      (left) {
        state = PendingAccountsErrorState(left.message);
      },
      (pendingAccounts) {
        state = PendingAccountsSuccessState(pendingAccounts: pendingAccounts);
      },
    );
  }

  Future<void> aprovePendingAccount({required int id}) async {
    state = PendingAccountsLoadingState();
    final response =
        await _pendingAccountsRepository.aprovePendingAccount(id: id);
    response.fold(
      (left) {
        state = PendingAccountsErrorState(left.message);
      },
      (isActivated) {
        if (isActivated) {
          getPendingAccounts();
        }
      },
    );
  }
}

final pendingAccountsProvider =
    StateNotifierProvider<PendingAccountsNotifier, PendingAccountsState>((ref) {
  final repository = ref.watch(pendingAccountsRepositoryProvider);
  return PendingAccountsNotifier(repository);
});
