import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import '../../domain/entities/asignatura_asignada.dart';
import '../datasources/asignaturas_asignadas_datasource.dart';
import '../models/asignatura_asignada_model.dart';

class AsignaturasAsignadasRemoteDatasourceImpl
    implements AsignaturasAsignadasDatasource {
  final Dio dio;

  AsignaturasAsignadasRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<AsignaturaAsignada>> getAsignaturasAsignadas(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${Constants.baseUrl}api/docente/mis-asignaturas-asignadas',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data
            .map((json) => AsignaturaAsignadaModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Error al obtener asignaturas asignadas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
