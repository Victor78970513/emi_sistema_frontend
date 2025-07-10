import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/solicitudes_admin_repository_impl.dart';
import '../../data/datasources/solicitudes_admin_remote_datasource.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// Estado para las acciones de solicitudes
class SolicitudesActionsState {
  final bool isApproving;
  final bool isRejecting;
  final String? error;
  final String? successMessage;

  SolicitudesActionsState({
    this.isApproving = false,
    this.isRejecting = false,
    this.error,
    this.successMessage,
  });

  SolicitudesActionsState copyWith({
    bool? isApproving,
    bool? isRejecting,
    String? error,
    String? successMessage,
  }) {
    return SolicitudesActionsState(
      isApproving: isApproving ?? this.isApproving,
      isRejecting: isRejecting ?? this.isRejecting,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

// StateNotifier para manejar las acciones de solicitudes
class SolicitudesActionsNotifier
    extends StateNotifier<SolicitudesActionsState> {
  final SolicitudesAdminRepositoryImpl repository;

  SolicitudesActionsNotifier(this.repository)
      : super(SolicitudesActionsState());

  Future<void> aprobarSolicitud(String token, String solicitudId) async {
    try {
      state =
          state.copyWith(isApproving: true, error: null, successMessage: null);

      final response = await repository.aprobarSolicitud(token, solicitudId);

      state = state.copyWith(
        isApproving: false,
        successMessage:
            response['message'] ?? 'Solicitud aprobada correctamente',
      );
    } catch (e) {
      state = state.copyWith(
        isApproving: false,
        error: e.toString(),
      );
    }
  }

  Future<void> rechazarSolicitud(String token, String solicitudId) async {
    try {
      state =
          state.copyWith(isRejecting: true, error: null, successMessage: null);

      await repository.rechazarSolicitud(token, solicitudId);

      state = state.copyWith(
        isRejecting: false,
        successMessage: 'Solicitud rechazada correctamente',
      );
    } catch (e) {
      state = state.copyWith(
        isRejecting: false,
        error: e.toString(),
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

// Provider para el datasource
final solicitudesActionsDataSourceProvider =
    Provider<SolicitudesAdminRemoteDataSource>((ref) {
  return SolicitudesAdminRemoteDataSourceImpl(client: http.Client());
});

// Provider para el repositorio
final solicitudesActionsRepositoryProvider =
    Provider<SolicitudesAdminRepositoryImpl>((ref) {
  final dataSource = ref.watch(solicitudesActionsDataSourceProvider);
  return SolicitudesAdminRepositoryImpl(remoteDataSource: dataSource);
});

// Provider para las acciones de solicitudes
final solicitudesActionsProvider =
    StateNotifierProvider<SolicitudesActionsNotifier, SolicitudesActionsState>(
        (ref) {
  final repository = ref.watch(solicitudesActionsRepositoryProvider);
  return SolicitudesActionsNotifier(repository);
});
