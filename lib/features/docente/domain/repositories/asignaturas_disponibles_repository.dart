import '../entities/asignatura_disponible.dart';

abstract class AsignaturasDisponiblesRepository {
  Future<Map<String, List<AsignaturaDisponible>>> getAsignaturasDisponibles(
      String token);
}
