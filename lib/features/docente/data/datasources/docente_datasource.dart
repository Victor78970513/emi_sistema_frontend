import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/docente_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class DocenteRemoteDatasource {
  Future<DocenteModel> getPersonalInfor();
  Future<List<CarreraModel>> getCarreras();
  Future<List<DocenteModel>> getAllDocentes();
  Future<List<EstudioAcademicoModel>> getEstudiosAcademicos(
      {required int docenteId});
  Future<DocenteModel> updateDocenteProfile(Map<String, dynamic> profileData);
  Future<DocenteModel> uploadDocentePhoto(dynamic photoFile);
}

class DocenteRemoteDatasourceImpl implements DocenteRemoteDatasource {
  final dio = Dio();
  final prefs = Preferences();

  Dio _getDioWithAuth() {
    final dio = Dio();
    final token = prefs.userToken;
    if (token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return dio;
  }

  @override
  Future<DocenteModel> getPersonalInfor() async {
    try {
      final authDio = _getDioWithAuth();
      final response = await authDio.get(
        // "http://localhost:3000/api/docente/me",
        "${Constants.baseUrl}api/docente/me",
      );

      print(
          "DocenteDatasource - Respuesta información personal: ${response.data}");
      final docente = DocenteModel.fromJson(response.data);
      return docente;
    } catch (e) {
      print("Error en getPersonalInfor: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al traer la informacion personal");
    }
  }

  @override
  Future<List<CarreraModel>> getCarreras() async {
    try {
      final authDio = _getDioWithAuth();
      final response = await authDio.get(
        // 'http://localhost:3000/api/docente/carreras',
        "${Constants.baseUrl}api/docente/carreras",
      );
      final data = response.data as List;
      return data.map((json) => CarreraModel.fromJson(json)).toList();
    } catch (e) {
      print("Error en getCarreras: ${e.toString()}");
      throw ServerException("Error al obtener las carreras");
    }
  }

  @override
  Future<List<DocenteModel>> getAllDocentes() async {
    try {
      print("DocenteDatasource - Obteniendo todos los docentes");
      final authDio = _getDioWithAuth();
      final response = await authDio.get(
        // "http://localhost:3000/api/docente/all",
        "${Constants.baseUrl}api/docente/all",
      );

      print("DocenteDatasource - Respuesta del backend: ${response.data}");

      final data = response.data as List<dynamic>;
      final docentes =
          data.map((docente) => DocenteModel.fromJson(docente)).toList();

      print("DocenteDatasource - Docentes procesados: ${docentes.length}");

      return docentes;
    } catch (e) {
      print("Error en getAllDocentes: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al traer la lista de docentes");
    }
  }

  @override
  Future<List<EstudioAcademicoModel>> getEstudiosAcademicos(
      {required int docenteId}) async {
    try {
      print(
          "DocenteDatasource - Obteniendo estudios académicos para docente: $docenteId");
      final authDio = _getDioWithAuth();
      final response = await authDio.get(
        // "http://localhost:3000/api/docente/$docenteId/estudios-academicos",
        "${Constants.baseUrl}api/docente/$docenteId/estudios-academicos",
      );

      print(
          "DocenteDatasource - Respuesta estudios académicos: ${response.data}");

      final data = response.data as List<dynamic>;
      final estudios = data
          .map((estudio) => EstudioAcademicoModel.fromJson(estudio))
          .toList();

      print("DocenteDatasource - Estudios procesados: ${estudios.length}");

      return estudios;
    } catch (e) {
      print("Error en getEstudiosAcademicos: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al traer los estudios académicos");
    }
  }

  @override
  Future<DocenteModel> updateDocenteProfile(
      Map<String, dynamic> profileData) async {
    try {
      print("DocenteDatasource - Actualizando perfil del docente");
      final authDio = _getDioWithAuth();
      final response = await authDio.put(
        // "http://localhost:3000/api/docente/me",
        "${Constants.baseUrl}api/docente/me",
        data: profileData,
      );

      print("DocenteDatasource - Respuesta actualización: ${response.data}");
      final docente = DocenteModel.fromJson(response.data);
      return docente;
    } catch (e) {
      print("Error en updateDocenteProfile: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al actualizar el perfil del docente");
    }
  }

  @override
  Future<DocenteModel> uploadDocentePhoto(dynamic photoFile) async {
    try {
      print("DocenteDatasource - Subiendo foto del docente");

      final authDio = _getDioWithAuth();

      // Crear FormData con la foto
      FormData formData;

      if (kIsWeb) {
        // Para web, photoFile ya es Uint8List
        formData = FormData.fromMap({
          'foto': MultipartFile.fromBytes(
            photoFile,
            filename: 'foto.png',
            contentType: DioMediaType('image', 'png'),
          ),
        });
      } else {
        // Para móvil, usar File directamente
        formData = FormData.fromMap({
          'foto': await MultipartFile.fromFile(
            photoFile.path,
            filename: photoFile.path.split('/').last,
            contentType: DioMediaType('image', 'png'),
          ),
        });
      }

      final response = await authDio.post(
        // "http://localhost:3000/api/docente/photo",
        "${Constants.baseUrl}api/docente/photo",
        data: formData,
      );

      print("DocenteDatasource - Respuesta subida de foto: ${response.data}");

      // La respuesta del backend incluye message, filename y docente
      final responseData = response.data;
      if (responseData['docente'] != null) {
        final docente = DocenteModel.fromJson(responseData['docente']);
        return docente;
      } else {
        throw ServerException("Respuesta inválida del servidor");
      }
    } catch (e) {
      print("Error en uploadDocentePhoto: ${e.toString()}");
      if (e is DioException) {
        print("Status code: ${e.response?.statusCode}");
        print("Response data: ${e.response?.data}");
      }
      throw ServerException("Error al subir la foto del docente");
    }
  }
}
