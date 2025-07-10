import '../../domain/entities/carrera_asignada.dart';
import '../../domain/repositories/carreras_asignadas_repository.dart';
import '../datasources/carreras_asignadas_datasource.dart';

class CarrerasAsignadasRepositoryImpl implements CarrerasAsignadasRepository {
  final CarrerasAsignadasDatasource datasource;

  CarrerasAsignadasRepositoryImpl({required this.datasource});

  @override
  Future<List<CarreraAsignada>> getCarrerasAsignadas(String token) async {
    return await datasource.getCarrerasAsignadas(token);
  }
}
