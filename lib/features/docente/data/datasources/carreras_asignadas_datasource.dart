import '../../domain/entities/carrera_asignada.dart';

abstract class CarrerasAsignadasDatasource {
  Future<List<CarreraAsignada>> getCarrerasAsignadas(String token);
}
