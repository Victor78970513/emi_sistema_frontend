import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/solicitud_admin_model.dart';
import '../../../../core/constants/constants.dart';

abstract class SolicitudesAdminRemoteDataSource {
  Future<List<SolicitudAdminModel>> getSolicitudes(String token);
  Future<Map<String, dynamic>> aprobarSolicitud(
      String token, String solicitudId);
  Future<void> rechazarSolicitud(String token, String solicitudId);
}

class SolicitudesAdminRemoteDataSourceImpl
    implements SolicitudesAdminRemoteDataSource {
  final http.Client client;

  SolicitudesAdminRemoteDataSourceImpl({required this.client});

  @override
  Future<List<SolicitudAdminModel>> getSolicitudes(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}api/admin/solicitudes'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => SolicitudAdminModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al obtener solicitudes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> aprobarSolicitud(
      String token, String solicitudId) async {
    try {
      final response = await client.put(
        Uri.parse(
            '${Constants.baseUrl}api/admin/solicitudes/$solicitudId/approve'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else {
        throw Exception('Error al aprobar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<void> rechazarSolicitud(String token, String solicitudId) async {
    try {
      final response = await client.put(
        Uri.parse(
            '${Constants.baseUrl}api/admin/solicitudes/$solicitudId/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Error al rechazar solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
