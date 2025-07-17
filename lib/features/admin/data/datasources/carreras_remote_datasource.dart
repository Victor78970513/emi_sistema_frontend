import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../models/carreras_response_model.dart';
import '../models/asignatura_detalle_model.dart';
import '../models/docentes_asignatura_response_model.dart';
import '../models/asociar_docente_response_model.dart';
import '../models/desasociar_docente_response_model.dart';
import '../models/asociar_docente_request_model.dart';
import '../models/docente_detalle_response_model.dart';
import '../../../../core/constants/constants.dart';
import 'dart:typed_data';

abstract class CarrerasRemoteDataSource {
  Future<CarrerasResponseModel> getCarreras(String token);
  Future<AsignaturaDetalleModel> getAsignaturaDetalle(
      String token, String asignaturaId);
  Future<DocentesAsignaturaResponseModel> getDocentesAsignatura(
      String token, String asignaturaId);
  Future<AsociarDocenteResponseModel> asociarDocente(
      String token, String asignaturaId, AsociarDocenteRequestModel request);
  Future<DesasociarDocenteResponseModel> desasociarDocente(
      String token, String asignaturaId, String docenteId);
  Future<DocenteDetalleResponseModel> getDocenteDetalle(
      String token, String docenteId);
  Future<Uint8List> descargarReporteAsignaturas(String token, String carreraId);
}

class CarrerasRemoteDataSourceImpl implements CarrerasRemoteDataSource {
  final http.Client client;

  CarrerasRemoteDataSourceImpl({required this.client});

  @override
  Future<CarrerasResponseModel> getCarreras(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}api/admin/asignaturas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return CarrerasResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception('Error al obtener carreras: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<AsignaturaDetalleModel> getAsignaturaDetalle(
      String token, String asignaturaId) async {
    try {
      print(
          'DEBUG: Datasource - Llamando a API para asignatura: $asignaturaId');
      final url = '${Constants.baseUrl}api/admin/asignaturas/$asignaturaId';
      print('DEBUG: Datasource - URL: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('DEBUG: Datasource - JSON decodificado correctamente');
        return AsignaturaDetalleModel.fromJson(jsonResponse);
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al obtener detalles de asignatura: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<DocentesAsignaturaResponseModel> getDocentesAsignatura(
      String token, String asignaturaId) async {
    try {
      print(
          'DEBUG: Datasource - Llamando a API para docentes de asignatura: $asignaturaId');
      final url =
          '${Constants.baseUrl}api/admin/asignaturas/$asignaturaId/docentes';
      print('DEBUG: Datasource - URL: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('DEBUG: Datasource - JSON decodificado correctamente');
        return DocentesAsignaturaResponseModel.fromJson(jsonResponse);
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al obtener docentes de asignatura: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<AsociarDocenteResponseModel> asociarDocente(String token,
      String asignaturaId, AsociarDocenteRequestModel request) async {
    try {
      print(
          'DEBUG: Datasource - Asociando docente a asignatura: $asignaturaId');
      final url =
          '${Constants.baseUrl}api/admin/asignaturas/$asignaturaId/docentes';
      print('DEBUG: Datasource - URL: $url');

      final response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()),
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('DEBUG: Datasource - JSON decodificado correctamente');
        return AsociarDocenteResponseModel.fromJson(jsonResponse);
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al asociar docente a asignatura: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<DesasociarDocenteResponseModel> desasociarDocente(
      String token, String asignaturaId, String docenteId) async {
    try {
      print(
          'DEBUG: Datasource - Desasociando docente de asignatura: $asignaturaId');
      final url =
          '${Constants.baseUrl}api/admin/asignaturas/$asignaturaId/docentes/$docenteId';
      print('DEBUG: Datasource - URL: $url');

      final response = await client.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('DEBUG: Datasource - JSON decodificado correctamente');
        return DesasociarDocenteResponseModel.fromJson(jsonResponse);
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al desasociar docente de asignatura: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<DocenteDetalleResponseModel> getDocenteDetalle(
      String token, String docenteId) async {
    try {
      print('DEBUG: Datasource - Obteniendo detalles del docente: $docenteId');
      final response = await client.get(
        Uri.parse('${Constants.baseUrl}api/admin/docentes/$docenteId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('DEBUG: Datasource - JSON decodificado correctamente');
        return DocenteDetalleResponseModel.fromJson(jsonResponse);
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al obtener detalles del docente: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  @override
  Future<Uint8List> descargarReporteAsignaturas(
      String token, String carreraId) async {
    try {
      print(
          'DEBUG: Datasource - Descargando reporte de asignaturas para carrera: $carreraId');
      final url =
          '${Constants.baseUrl}api/admin/asignaturas/reporte/$carreraId';
      print('DEBUG: Datasource - URL: $url');

      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/pdf', // Indicar que es un PDF
          'Authorization': 'Bearer $token',
        },
      );

      print('DEBUG: Datasource - Status code: ${response.statusCode}');
      print('DEBUG: Datasource - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('DEBUG: Datasource - Error status code: ${response.statusCode}');
        throw Exception(
            'Error al descargar el reporte de asignaturas: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Datasource - Error de conexión: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
