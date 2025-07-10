import '../../domain/entities/asignatura_asignada.dart';
import '../../domain/repositories/asignaturas_asignadas_repository.dart';
import '../datasources/asignaturas_asignadas_datasource.dart';

class AsignaturasAsignadasRepositoryImpl
    implements AsignaturasAsignadasRepository {
  final AsignaturasAsignadasDatasource datasource;

  AsignaturasAsignadasRepositoryImpl({required this.datasource});

  @override
  Future<List<AsignaturaAsignada>> getAsignaturasAsignadas(String token) async {
    return await datasource.getAsignaturasAsignadas(token);
  }
}
