import '../../domain/entities/solicitud.dart';
import '../../domain/repositories/solicitudes_repository.dart';
import '../datasources/solicitudes_datasource.dart';

class SolicitudesRepositoryImpl implements SolicitudesRepository {
  final SolicitudesDatasource datasource;

  SolicitudesRepositoryImpl({required this.datasource});

  @override
  Future<Solicitud> crearSolicitud(
      String token, String tipoSolicitud, int id) async {
    return await datasource.crearSolicitud(token, tipoSolicitud, id);
  }
}
