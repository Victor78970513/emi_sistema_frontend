import '../entities/asignatura_asignada.dart';

abstract class AsignaturasAsignadasRepository {
  Future<List<AsignaturaAsignada>> getAsignaturasAsignadas(String token);
}
