import 'carrera_simple_model.dart';

class AsignaturaDetalleModel {
  final String id;
  final String materia;
  final int gestion;
  final String periodo;
  final int sem;
  final String semestres;
  final int cargaHoraria;
  final String creadoEn;
  final String modificadoEn;
  final CarreraSimpleModel carrera;

  AsignaturaDetalleModel({
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

  factory AsignaturaDetalleModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaDetalleModel(
      id: json['id'] ?? '',
      materia: json['materia'] ?? '',
      gestion: json['gestion'] ?? 0,
      periodo: json['periodo'] ?? '',
      sem: json['sem'] ?? 0,
      semestres: json['semestres'] ?? '',
      cargaHoraria: json['carga_horaria'] ?? 0,
      creadoEn: json['creado_en'] ?? '',
      modificadoEn: json['modificado_en'] ?? '',
      carrera: CarreraSimpleModel.fromJson(json['carrera'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materia': materia,
      'gestion': gestion,
      'periodo': periodo,
      'sem': sem,
      'semestres': semestres,
      'carga_horaria': cargaHoraria,
      'creado_en': creadoEn,
      'modificado_en': modificadoEn,
      'carrera': carrera.toJson(),
    };
  }
}
