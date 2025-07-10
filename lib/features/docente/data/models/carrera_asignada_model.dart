import '../../domain/entities/carrera_asignada.dart';

class CarreraAsignadaModel extends CarreraAsignada {
  CarreraAsignadaModel({
    required super.id,
    required super.docenteId,
    required super.carreraId,
    required super.creadoEn,
    required super.modificadoEn,
    required super.docenteNombre,
    required super.carreraNombre,
  });

  factory CarreraAsignadaModel.fromJson(Map<String, dynamic> json) {
    return CarreraAsignadaModel(
      id: json['id'].toString(),
      docenteId: json['docente_id'].toString(),
      carreraId: json['carrera_id'].toString(),
      creadoEn: DateTime.parse(json['creado_en']),
      modificadoEn: DateTime.parse(json['modificado_en']),
      docenteNombre: json['docente_nombre'],
      carreraNombre: json['carrera_nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docente_id': docenteId,
      'carrera_id': carreraId,
      'creado_en': creadoEn.toIso8601String(),
      'modificado_en': modificadoEn.toIso8601String(),
      'docente_nombre': docenteNombre,
      'carrera_nombre': carreraNombre,
    };
  }
}
