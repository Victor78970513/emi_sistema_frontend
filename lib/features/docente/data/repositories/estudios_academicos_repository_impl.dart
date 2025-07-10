import 'package:frontend_emi_sistema/core/constants/constants.dart';
import '../../domain/entities/institucion.dart';
import '../../domain/entities/grado_academico.dart';
import '../../domain/repositories/estudios_academicos_repository.dart';
import 'package:dio/dio.dart';

class EstudiosAcademicosRepositoryImpl implements EstudiosAcademicosRepository {
  final Dio dio;
  EstudiosAcademicosRepositoryImpl(this.dio);

  @override
  Future<List<Institucion>> getInstituciones() async {
    final response =
        await dio.get('${Constants.baseUrl}api/docente/instituciones');
    return (response.data as List).map((e) => Institucion.fromJson(e)).toList();
  }

  @override
  Future<List<GradoAcademico>> getGrados() async {
    final response =
        await dio.get('${Constants.baseUrl}api/docente/grados-academicos');
    return (response.data as List)
        .map((e) => GradoAcademico.fromJson(e))
        .toList();
  }

  @override
  Future<void> createEstudioAcademico({
    required String titulo,
    required int institucionId,
    required int gradoId,
    required int anioTitulacion,
    required List<int> pdfBytes,
    required String pdfName,
    required String token,
  }) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    final formData = FormData.fromMap({
      'titulo': titulo,
      'institucion_id': institucionId,
      'grado_academico_id': gradoId,
      'año_titulacion': anioTitulacion,
      'documento': MultipartFile.fromBytes(pdfBytes, filename: pdfName),
    });
    await dio.post('${Constants.baseUrl}api/docente/estudios-academicos',
        data: formData);
  }
}
