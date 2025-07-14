import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/domain/repositories/pending_accounts_repository.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_repository_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';

class PendingAccountsNotifier extends StateNotifier<PendingAccountsState> {
  final PendingAccountsRepository _pendingAccountsRepository;
  final Ref ref;

  PendingAccountsNotifier(this._pendingAccountsRepository, this.ref)
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
    print('PendingAccountsNotifier: Aprobando cuenta $id');
    state = PendingAccountsLoadingState();
    final response =
        await _pendingAccountsRepository.aprovePendingAccount(id: id);
    response.fold(
      (left) {
        print(
            'PendingAccountsNotifier: Error al aprobar cuenta: ${left.message}');
        state = PendingAccountsErrorState(left.message);
      },
      (isActivated) {
        if (isActivated) {
          print(
              'PendingAccountsNotifier: Cuenta aprobada exitosamente, recargando datos...');
          getPendingAccounts();
          // Invalidar y recargar el provider de docentes
          ref.invalidate(docenteProvider);
          ref.read(docenteProvider.notifier).getAllDocentes();
        }
      },
    );
  }

  Future<void> rejectPendingAccount(
      {required int id, required String reason}) async {
    print('PendingAccountsNotifier: Rechazando cuenta $id');
    state = PendingAccountsLoadingState();
    final response = await _pendingAccountsRepository.rejectPendingAccount(
        id: id, reason: reason);
    response.fold(
      (left) {
        print(
            'PendingAccountsNotifier: Error al rechazar cuenta: ${left.message}');
        state = PendingAccountsErrorState(left.message);
      },
      (isRejected) {
        if (isRejected) {
          print(
              'PendingAccountsNotifier: Cuenta rechazada exitosamente, recargando datos...');
          getPendingAccounts();
          // Invalidar y recargar el provider de docentes
          ref.invalidate(docenteProvider);
          ref.read(docenteProvider.notifier).getAllDocentes();
        }
      },
    );
  }
}

final pendingAccountsProvider =
    StateNotifierProvider<PendingAccountsNotifier, PendingAccountsState>((ref) {
  final repository = ref.read(pendingAccountsRepositoryProvider);
  return PendingAccountsNotifier(repository, ref);
});
