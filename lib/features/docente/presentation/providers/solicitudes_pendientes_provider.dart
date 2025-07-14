import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/solicitud_pendiente.dart';
import '../../domain/repositories/solicitudes_pendientes_repository.dart';
import '../../data/repositories/solicitudes_pendientes_repository_impl.dart';
import '../../data/datasources/solicitudes_pendientes_remote_datasource.dart';
import 'package:dio/dio.dart';

// Estados
abstract class SolicitudesPendientesState {}

class SolicitudesPendientesInitial extends SolicitudesPendientesState {}

class SolicitudesPendientesLoading extends SolicitudesPendientesState {}

class SolicitudesPendientesSuccess extends SolicitudesPendientesState {
  final List<SolicitudPendiente> solicitudes;
  SolicitudesPendientesSuccess(this.solicitudes);
}

class SolicitudesPendientesError extends SolicitudesPendientesState {
  final String message;
  SolicitudesPendientesError(this.message);
}

// Notifier
class SolicitudesPendientesNotifier
    extends StateNotifier<SolicitudesPendientesState> {
  final SolicitudesPendientesRepository _repository;

  SolicitudesPendientesNotifier(this._repository)
      : super(SolicitudesPendientesInitial());

  Future<void> getSolicitudesPendientes(String token) async {
    state = SolicitudesPendientesLoading();

    final result = await _repository.getSolicitudesPendientes(token);

    result.fold(
      (failure) {
        state = SolicitudesPendientesError(failure.message);
      },
      (solicitudes) {
        state = SolicitudesPendientesSuccess(solicitudes);
      },
    );
  }
}

// Provider
final solicitudesPendientesProvider = StateNotifierProvider<
    SolicitudesPendientesNotifier, SolicitudesPendientesState>((ref) {
  final dio = Dio();
  final datasource = SolicitudesPendientesRemoteDatasourceImpl(dio: dio);
  final repository =
      SolicitudesPendientesRepositoryImpl(datasource: datasource);
  return SolicitudesPendientesNotifier(repository);
});
