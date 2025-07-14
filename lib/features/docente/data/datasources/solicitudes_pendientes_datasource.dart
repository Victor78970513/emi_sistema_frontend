import '../../domain/entities/solicitud_pendiente.dart';

abstract class SolicitudesPendientesDatasource {
  Future<List<SolicitudPendiente>> getSolicitudesPendientes(String token);
}
