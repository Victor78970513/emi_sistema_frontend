import '../entities/solicitud.dart';

abstract class SolicitudesRepository {
  Future<Solicitud> crearSolicitud(String token, String tipoSolicitud, int id);
}
