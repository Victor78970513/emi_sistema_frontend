import '../entities/carrera_asignada.dart';

abstract class CarrerasAsignadasRepository {
  Future<List<CarreraAsignada>> getCarrerasAsignadas(String token);
}
