import '../entities/institucion.dart';
import '../entities/grado_academico.dart';

abstract class EstudiosAcademicosRepository {
  Future<List<Institucion>> getInstituciones();
  Future<List<GradoAcademico>> getGrados();
  Future<void> createEstudioAcademico({
    required String titulo,
    required int institucionId,
    required int gradoId,
    required int anioTitulacion,
    required List<int> pdfBytes,
    required String pdfName,
    required String token,
  });
}
