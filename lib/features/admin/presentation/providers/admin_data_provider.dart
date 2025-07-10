import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'pending_accounts_provider.dart';
import 'solicitudes_admin_provider.dart';
import '../../../docente/presentation/providers/docente_provider.dart';

// Estado para el admin data provider
class AdminDataState {
  final bool isLoading;
  final String? error;
  final bool isInitialized;

  AdminDataState({
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
  });

  AdminDataState copyWith({
    bool? isLoading,
    String? error,
    bool? isInitialized,
  }) {
    return AdminDataState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

// StateNotifier para manejar la carga de datos del admin
class AdminDataNotifier extends StateNotifier<AdminDataState> {
  final Ref ref;

  AdminDataNotifier(this.ref) : super(AdminDataState());

  Future<void> loadAllData() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final token = Preferences().userToken;

      // Cargar todas las cuentas pendientes
      await ref.read(pendingAccountsProvider.notifier).getPendingAccounts();

      // Cargar todos los docentes
      await ref.read(docenteProvider.notifier).getAllDocentes();

      // Cargar todas las solicitudes (el FutureProvider se ejecuta automáticamente)
      ref.read(solicitudesAdminProvider(token));

      print(
          'AdminDataNotifier: Todos los datos han sido cargados exitosamente');
      state = state.copyWith(isLoading: false, isInitialized: true);
    } catch (e) {
      print('AdminDataNotifier: Error cargando datos: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshAllData() async {
    try {
      print('AdminDataNotifier: Iniciando refreshAllData...');
      state = state.copyWith(isLoading: true, error: null);

      final token = Preferences().userToken;

      // Invalidar los providers para forzar recarga
      print('AdminDataNotifier: Invalidando providers...');
      ref.invalidate(pendingAccountsProvider);
      ref.invalidate(docenteProvider);
      ref.invalidate(solicitudesAdminProvider(token));

      // Recargar todos los datos
      print('AdminDataNotifier: Recargando cuentas pendientes...');
      await ref.read(pendingAccountsProvider.notifier).getPendingAccounts();

      print('AdminDataNotifier: Recargando docentes...');
      await ref.read(docenteProvider.notifier).getAllDocentes();

      print('AdminDataNotifier: Recargando solicitudes...');
      ref.read(solicitudesAdminProvider(token));

      print(
          'AdminDataNotifier: Todos los datos han sido refrescados exitosamente');
      state = state.copyWith(isLoading: false, isInitialized: true);
    } catch (e) {
      print('AdminDataNotifier: Error refrescando datos: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// Provider para el admin data notifier
final adminDataProvider =
    StateNotifierProvider<AdminDataNotifier, AdminDataState>((ref) {
  return AdminDataNotifier(ref);
});
