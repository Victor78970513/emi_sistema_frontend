import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import '../../domain/entities/asignatura_disponible.dart';
import '../datasources/asignaturas_disponibles_datasource.dart';
import '../models/asignatura_disponible_model.dart';

class AsignaturasDisponiblesRemoteDatasourceImpl
    implements AsignaturasDisponiblesDatasource {
  final Dio dio;

  AsignaturasDisponiblesRemoteDatasourceImpl({required this.dio});

  @override
  Future<Map<String, List<AsignaturaDisponible>>> getAsignaturasDisponibles(
      String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${Constants.baseUrl}api/docente/asignaturas',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;

        Map<String, List<AsignaturaDisponible>> result = {};

        data.forEach((carreraNombre, asignaturasList) {
          List<AsignaturaDisponible> asignaturas = [];

          // Verificar que asignaturasList sea una lista
          if (asignaturasList is List) {
            for (var asignaturaData in asignaturasList) {
              try {
                if (asignaturaData is Map<String, dynamic>) {
                  asignaturas
                      .add(AsignaturaDisponibleModel.fromJson(asignaturaData));
                }
              } catch (e) {
                print('Error parsing asignatura: $e');
                print('Asignatura data: $asignaturaData');
              }
            }
          }

          if (asignaturas.isNotEmpty) {
            result[carreraNombre] = asignaturas;
          }
        });
        return result;
      } else {
        throw Exception(
            'Error al obtener asignaturas disponibles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAsignaturasDisponibles: $e');
      if (e is DioException) {
        print('DioException status: ${e.response?.statusCode}');
        print('DioException data: ${e.response?.data}');
        print('DioException message: ${e.message}');
      }
      throw Exception('Error de conexión: $e');
    }
  }
}
