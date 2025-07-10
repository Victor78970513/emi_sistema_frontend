import 'package:dio/dio.dart';
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
      throw Exception('Error de conexión: $e');
    }
  }
}
