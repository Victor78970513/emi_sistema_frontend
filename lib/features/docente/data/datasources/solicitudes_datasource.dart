import '../../domain/entities/solicitud.dart';

abstract class SolicitudesDatasource {
  Future<Solicitud> crearSolicitud(String token, String tipoSolicitud, int id);
}
