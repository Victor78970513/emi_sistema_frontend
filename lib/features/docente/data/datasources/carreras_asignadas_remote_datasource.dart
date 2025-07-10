import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import '../../domain/entities/carrera_asignada.dart';
import '../datasources/carreras_asignadas_datasource.dart';
import '../models/carrera_asignada_model.dart';

class CarrerasAsignadasRemoteDatasourceImpl
    implements CarrerasAsignadasDatasource {
  final Dio dio;

  CarrerasAsignadasRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<CarreraAsignada>> getCarrerasAsignadas(String token) async {
    try {
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.get(
        '${Constants.baseUrl}api/docente/carreras-asignadas',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CarreraAsignadaModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener carreras asignadas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
