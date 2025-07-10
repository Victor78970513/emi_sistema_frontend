import '../../domain/entities/asignatura_disponible.dart';

abstract class AsignaturasDisponiblesDatasource {
  Future<Map<String, List<AsignaturaDisponible>>> getAsignaturasDisponibles(
      String token);
}
