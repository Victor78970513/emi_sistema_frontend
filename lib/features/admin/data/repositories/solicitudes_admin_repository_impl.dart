import '../../domain/entities/solicitud_admin.dart';
import '../../domain/repositories/solicitudes_admin_repository.dart';
import '../datasources/solicitudes_admin_remote_datasource.dart';

class SolicitudesAdminRepositoryImpl implements SolicitudesAdminRepository {
  final SolicitudesAdminRemoteDataSource remoteDataSource;

  SolicitudesAdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SolicitudAdmin>> getSolicitudes(String token) async {
    try {
      final solicitudes = await remoteDataSource.getSolicitudes(token);
      return solicitudes;
    } catch (e) {
      throw Exception('Error al obtener solicitudes: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> aprobarSolicitud(
      String token, String solicitudId) async {
    try {
      final response =
          await remoteDataSource.aprobarSolicitud(token, solicitudId);
      return response;
    } catch (e) {
      throw Exception('Error al aprobar solicitud: $e');
    }
  }

  @override
  Future<void> rechazarSolicitud(String token, String solicitudId) async {
    try {
      await remoteDataSource.rechazarSolicitud(token, solicitudId);
    } catch (e) {
      throw Exception('Error al rechazar solicitud: $e');
    }
  }
}
