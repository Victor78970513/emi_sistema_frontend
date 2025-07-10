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
      print('Token recibido: ${token.substring(0, 20)}...');
      print('URL: ${Constants.baseUrl}api/docente/asignaturas');

      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${Constants.baseUrl}api/docente/asignaturas',
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        print('Data keys: ${data.keys.toList()}');

        Map<String, List<AsignaturaDisponible>> result = {};

        data.forEach((carreraNombre, asignaturasList) {
          print('Procesando carrera: $carreraNombre');
          print('AsignaturasList type: ${asignaturasList.runtimeType}');
          print('AsignaturasList: $asignaturasList');

          List<AsignaturaDisponible> asignaturas = [];

          // Verificar que asignaturasList sea una lista
          if (asignaturasList is List) {
            print(
                'AsignaturasList es una lista con ${asignaturasList.length} elementos');
            for (var asignaturaData in asignaturasList) {
              try {
                if (asignaturaData is Map<String, dynamic>) {
                  print('Procesando asignatura: $asignaturaData');
                  asignaturas
                      .add(AsignaturaDisponibleModel.fromJson(asignaturaData));
                } else {
                  print(
                      'AsignaturaData no es Map: ${asignaturaData.runtimeType}');
                }
              } catch (e) {
                print('Error parsing asignatura: $e');
                print('Asignatura data: $asignaturaData');
              }
            }
          } else {
            print(
                'AsignaturasList no es una lista: ${asignaturasList.runtimeType}');
          }

          if (asignaturas.isNotEmpty) {
            result[carreraNombre] = asignaturas;
            print(
                'Agregadas ${asignaturas.length} asignaturas para $carreraNombre');
          }
        });

        print('Resultado final: $result');
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
