import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/asignatura_asignada.dart';
import '../../domain/repositories/asignaturas_asignadas_repository.dart';
import '../../data/repositories/asignaturas_asignadas_repository_impl.dart';
import '../../data/datasources/asignaturas_asignadas_remote_datasource.dart';
import 'package:dio/dio.dart';

// Estados
abstract class AsignaturasAsignadasState {}

class AsignaturasAsignadasInitial extends AsignaturasAsignadasState {}

class AsignaturasAsignadasLoading extends AsignaturasAsignadasState {}

class AsignaturasAsignadasSuccess extends AsignaturasAsignadasState {
  final List<AsignaturaAsignada> asignaturas;
  AsignaturasAsignadasSuccess(this.asignaturas);
}

class AsignaturasAsignadasError extends AsignaturasAsignadasState {
  final String message;
  AsignaturasAsignadasError(this.message);
}

// Notifier
class AsignaturasAsignadasNotifier
    extends StateNotifier<AsignaturasAsignadasState> {
  final AsignaturasAsignadasRepository _repository;

  AsignaturasAsignadasNotifier(this._repository)
      : super(AsignaturasAsignadasInitial());

  Future<void> getAsignaturasAsignadas(String token) async {
    state = AsignaturasAsignadasLoading();
    try {
      final asignaturas = await _repository.getAsignaturasAsignadas(token);
      state = AsignaturasAsignadasSuccess(asignaturas);
    } catch (e) {
      state = AsignaturasAsignadasError(e.toString());
    }
  }
}

// Provider
final asignaturasAsignadasProvider = StateNotifierProvider<
    AsignaturasAsignadasNotifier, AsignaturasAsignadasState>((ref) {
  final dio = Dio();
  final datasource = AsignaturasAsignadasRemoteDatasourceImpl(dio: dio);
  final repository = AsignaturasAsignadasRepositoryImpl(datasource: datasource);
  return AsignaturasAsignadasNotifier(repository);
});
