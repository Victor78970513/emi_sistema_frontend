import '../../domain/entities/asignatura_disponible.dart';

class AsignaturaDisponibleModel extends AsignaturaDisponible {
  AsignaturaDisponibleModel({
    required super.id,
    required super.gestion,
    required super.periodo,
    required super.materia,
    required super.sem,
    required super.semestres,
    required super.cargaHoraria,
    required super.carreraId,
    required super.creadoEn,
    required super.modificadoEn,
    required super.carreraNombre,
  });

  factory AsignaturaDisponibleModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaDisponibleModel(
      id: int.parse(json['id'].toString()),
      gestion: json['gestion'],
      periodo: json['periodo'],
      materia: json['materia'],
      sem: json['sem'],
      semestres: json['semestres'],
      cargaHoraria: json['carga_horaria'],
      carreraId: json['carrera_id'].toString(),
      creadoEn: DateTime.parse(json['creado_en']),
      modificadoEn: DateTime.parse(json['modificado_en']),
      carreraNombre: json['carrera_nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gestion': gestion,
      'periodo': periodo,
      'materia': materia,
      'sem': sem,
      'semestres': semestres,
      'carga_horaria': cargaHoraria,
      'carrera_id': carreraId,
      'creado_en': creadoEn.toIso8601String(),
      'modificado_en': modificadoEn.toIso8601String(),
      'carrera_nombre': carreraNombre,
    };
  }
}
