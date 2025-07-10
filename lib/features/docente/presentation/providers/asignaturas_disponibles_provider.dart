import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/asignatura_disponible.dart';
import '../../domain/repositories/asignaturas_disponibles_repository.dart';
import '../../data/repositories/asignaturas_disponibles_repository_impl.dart';
import '../../data/datasources/asignaturas_disponibles_remote_datasource.dart';
import 'package:dio/dio.dart';

// Estados
abstract class AsignaturasDisponiblesState {}

class AsignaturasDisponiblesInitial extends AsignaturasDisponiblesState {}

class AsignaturasDisponiblesLoading extends AsignaturasDisponiblesState {}

class AsignaturasDisponiblesSuccess extends AsignaturasDisponiblesState {
  final Map<String, List<AsignaturaDisponible>> asignaturas;
  AsignaturasDisponiblesSuccess(this.asignaturas);
}

class AsignaturasDisponiblesError extends AsignaturasDisponiblesState {
  final String message;
  AsignaturasDisponiblesError(this.message);
}

// Notifier
class AsignaturasDisponiblesNotifier
    extends StateNotifier<AsignaturasDisponiblesState> {
  final AsignaturasDisponiblesRepository _repository;

  AsignaturasDisponiblesNotifier(this._repository)
      : super(AsignaturasDisponiblesInitial());

  Future<void> getAsignaturasDisponibles(String token) async {
    state = AsignaturasDisponiblesLoading();
    try {
      final asignaturas = await _repository.getAsignaturasDisponibles(token);
      state = AsignaturasDisponiblesSuccess(asignaturas);
    } catch (e) {
      state = AsignaturasDisponiblesError(e.toString());
    }
  }
}

// Provider
final asignaturasDisponiblesProvider = StateNotifierProvider<
    AsignaturasDisponiblesNotifier, AsignaturasDisponiblesState>((ref) {
  final dio = Dio();
  final datasource = AsignaturasDisponiblesRemoteDatasourceImpl(dio: dio);
  final repository =
      AsignaturasDisponiblesRepositoryImpl(datasource: datasource);
  return AsignaturasDisponiblesNotifier(repository);
});
