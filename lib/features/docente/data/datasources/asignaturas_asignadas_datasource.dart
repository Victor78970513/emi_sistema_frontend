import '../../domain/entities/asignatura_asignada.dart';

abstract class AsignaturasAsignadasDatasource {
  Future<List<AsignaturaAsignada>> getAsignaturasAsignadas(String token);
}
