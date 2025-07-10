import '../../domain/entities/asignatura_asignada.dart';

class AsignaturaAsignadaModel extends AsignaturaAsignada {
  AsignaturaAsignadaModel({
    required super.id,
    required super.docenteId,
    required super.asignaturaId,
    required super.creadoEn,
    required super.modificadoEn,
    required super.docenteNombre,
    required super.asignaturaNombre,
    required super.gestion,
    required super.periodo,
    required super.semestres,
  });

  factory AsignaturaAsignadaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaAsignadaModel(
      id: json['id'].toString(),
      docenteId: json['docente_id'].toString(),
      asignaturaId: json['asignatura_id'].toString(),
      creadoEn: DateTime.parse(json['creado_en']),
      modificadoEn: DateTime.parse(json['modificado_en']),
      docenteNombre: json['docente_nombre'],
      asignaturaNombre: json['asignatura_nombre'],
      gestion: json['gestion'],
      periodo: json['periodo'],
      semestres: json['semestres'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docente_id': docenteId,
      'asignatura_id': asignaturaId,
      'creado_en': creadoEn.toIso8601String(),
      'modificado_en': modificadoEn.toIso8601String(),
      'docente_nombre': docenteNombre,
      'asignatura_nombre': asignaturaNombre,
      'gestion': gestion,
      'periodo': periodo,
      'semestres': semestres,
    };
  }
}
