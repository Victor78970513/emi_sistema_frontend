import '../entities/solicitud_admin.dart';

abstract class SolicitudesAdminRepository {
  Future<List<SolicitudAdmin>> getSolicitudes(String token);
  Future<Map<String, dynamic>> aprobarSolicitud(
      String token, String solicitudId);
  Future<void> rechazarSolicitud(String token, String solicitudId);
}
