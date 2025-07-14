import 'carrera.dart';

class AsignaturaDetalle {
  final String id;
  final String materia;
  final int gestion;
  final String periodo;
  final int sem;
  final String semestres;
  final int cargaHoraria;
  final String creadoEn;
  final String modificadoEn;
  final Carrera carrera;

  AsignaturaDetalle({
    required this.id,
    required this.materia,
    required this.gestion,
    required this.periodo,
    required this.sem,
    required this.semestres,
    required this.cargaHoraria,
    required this.creadoEn,
    required this.modificadoEn,
    required this.carrera,
  });
}
