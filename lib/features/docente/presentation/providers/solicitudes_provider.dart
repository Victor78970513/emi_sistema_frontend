import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/solicitud.dart';
import '../../domain/repositories/solicitudes_repository.dart';
import '../../data/repositories/solicitudes_repository_impl.dart';
import '../../data/datasources/solicitudes_remote_datasource.dart';
import 'package:dio/dio.dart';

// Estados
abstract class SolicitudesState {}

class SolicitudesInitial extends SolicitudesState {}

class SolicitudesLoading extends SolicitudesState {}

class SolicitudesSuccess extends SolicitudesState {
  final Solicitud solicitud;
  SolicitudesSuccess(this.solicitud);
}

class SolicitudesError extends SolicitudesState {
  final String message;
  SolicitudesError(this.message);
}

// Notifier
class SolicitudesNotifier extends StateNotifier<SolicitudesState> {
  final SolicitudesRepository _repository;

  SolicitudesNotifier(this._repository) : super(SolicitudesInitial());

  Future<void> crearSolicitud(
      String token, String tipoSolicitud, int id) async {
    state = SolicitudesLoading();

    final result = await _repository.crearSolicitud(token, tipoSolicitud, id);

    result.fold(
      (failure) {
        state = SolicitudesError(failure.message);
        // Re-lanzar la excepción para que la UI pueda manejarla
        throw Exception(failure.message);
      },
      (solicitud) {
        state = SolicitudesSuccess(solicitud);
      },
    );
  }
}

// Provider
final solicitudesProvider =
    StateNotifierProvider<SolicitudesNotifier, SolicitudesState>((ref) {
  final dio = Dio();
  final datasource = SolicitudesRemoteDatasourceImpl(dio: dio);
  final repository = SolicitudesRepositoryImpl(datasource: datasource);
  return SolicitudesNotifier(repository);
});
