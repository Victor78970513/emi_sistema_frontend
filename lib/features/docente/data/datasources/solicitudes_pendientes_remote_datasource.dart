import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import '../../domain/entities/solicitud_pendiente.dart';
import '../datasources/solicitudes_pendientes_datasource.dart';
import '../models/solicitud_pendiente_model.dart';

class SolicitudesPendientesRemoteDatasourceImpl
    implements SolicitudesPendientesDatasource {
  final Dio dio;

  SolicitudesPendientesRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<SolicitudPendiente>> getSolicitudesPendientes(
      String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${Constants.baseUrl}api/docente/solicitudes-pendientes',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => SolicitudPendienteModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Error al obtener solicitudes pendientes');
      }
    } catch (e) {
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['error']?.toString() ?? '';
          if (errorMessage.isNotEmpty) {
            throw ServerException(errorMessage);
          }
        }
      }
      throw ServerException(
          'Error de conexión al obtener solicitudes pendientes');
    }
  }
}
