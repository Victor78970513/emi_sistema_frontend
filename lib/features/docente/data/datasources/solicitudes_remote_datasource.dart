import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import '../../domain/entities/solicitud.dart';
import '../datasources/solicitudes_datasource.dart';
import '../models/solicitud_model.dart';
import '../../../../core/constants/constants.dart';

class SolicitudesRemoteDatasourceImpl implements SolicitudesDatasource {
  final Dio dio;

  SolicitudesRemoteDatasourceImpl({required this.dio});

  @override
  Future<Solicitud> crearSolicitud(
      String token, String tipoSolicitud, int id) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      Map<String, dynamic> data = {
        'tipo_solicitud': tipoSolicitud,
      };

      if (tipoSolicitud == 'carrera') {
        data['carrera_id'] = id;
      } else if (tipoSolicitud == 'asignatura') {
        data['asignatura_id'] = id;
      }

      final response = await dio.post(
        '${Constants.baseUrl}api/docente/solicitudes',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = response.data;
        final Map<String, dynamic> solicitudData = responseData['solicitud'];
        return SolicitudModel.fromJson(solicitudData);
      } else {
        throw Exception('Error al crear solicitud');
      }
    } catch (e) {
      // Manejar errores específicos del backend
      if (e is DioException) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['error']?.toString() ?? '';

          // Mapear errores específicos a mensajes amigables
          if (errorMessage.contains('ya está asociado a esta carrera')) {
            throw ServerException(
                'Ya estás asociado a esta carrera. No puedes postular nuevamente.');
          } else if (errorMessage
              .contains('ya está asociado a esta asignatura')) {
            throw ServerException(
                'Ya estás asociado a esta asignatura. No puedes postular nuevamente.');
          } else if (errorMessage.isNotEmpty) {
            throw ServerException(errorMessage);
          }
        }
      }
      throw ServerException(
        'Error al enviar solicitud. Revisa si ya tienes una solicitud pendiente para la misma selección o intenta nuevamente más tarde.',
      );
    }
  }
}
