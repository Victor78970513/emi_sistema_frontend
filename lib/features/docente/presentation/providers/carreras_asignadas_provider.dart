import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/carrera_asignada.dart';
import '../../domain/repositories/carreras_asignadas_repository.dart';
import '../../data/repositories/carreras_asignadas_repository_impl.dart';
import '../../data/datasources/carreras_asignadas_remote_datasource.dart';
import 'package:dio/dio.dart';

// Estados
abstract class CarrerasAsignadasState {}

class CarrerasAsignadasInitial extends CarrerasAsignadasState {}

class CarrerasAsignadasLoading extends CarrerasAsignadasState {}

class CarrerasAsignadasSuccess extends CarrerasAsignadasState {
  final List<CarreraAsignada> carreras;
  CarrerasAsignadasSuccess(this.carreras);
}

class CarrerasAsignadasError extends CarrerasAsignadasState {
  final String message;
  CarrerasAsignadasError(this.message);
}

// Notifier
class CarrerasAsignadasNotifier extends StateNotifier<CarrerasAsignadasState> {
  final CarrerasAsignadasRepository _repository;

  CarrerasAsignadasNotifier(this._repository)
      : super(CarrerasAsignadasInitial());

  Future<void> getCarrerasAsignadas(String token) async {
    state = CarrerasAsignadasLoading();
    try {
      final carreras = await _repository.getCarrerasAsignadas(token);
      state = CarrerasAsignadasSuccess(carreras);
    } catch (e) {
      state = CarrerasAsignadasError(e.toString());
    }
  }
}

// Provider
final carrerasAsignadasProvider =
    StateNotifierProvider<CarrerasAsignadasNotifier, CarrerasAsignadasState>(
        (ref) {
  final dio = Dio();
  final datasource = CarrerasAsignadasRemoteDatasourceImpl(dio: dio);
  final repository = CarrerasAsignadasRepositoryImpl(datasource: datasource);
  return CarrerasAsignadasNotifier(repository);
});
