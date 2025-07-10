import '../../domain/entities/asignatura_disponible.dart';
import '../../domain/repositories/asignaturas_disponibles_repository.dart';
import '../datasources/asignaturas_disponibles_datasource.dart';

class AsignaturasDisponiblesRepositoryImpl
    implements AsignaturasDisponiblesRepository {
  final AsignaturasDisponiblesDatasource datasource;

  AsignaturasDisponiblesRepositoryImpl({required this.datasource});

  @override
  Future<Map<String, List<AsignaturaDisponible>>> getAsignaturasDisponibles(
      String token) async {
    return await datasource.getAsignaturasDisponibles(token);
  }
}
