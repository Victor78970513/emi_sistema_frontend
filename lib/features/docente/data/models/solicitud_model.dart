import '../../domain/entities/solicitud.dart';

class SolicitudModel extends Solicitud {
  SolicitudModel({
    required super.id,
    required super.docenteId,
    required super.tipoSolicitud,
    super.carreraId,
    super.asignaturaId,
    required super.estadoId,
    required super.creadoEn,
    required super.modificadoEn,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      id: json['id'].toString(),
      docenteId: json['docente_id'].toString(),
      tipoSolicitud: json['tipo_solicitud'],
      carreraId: json['carrera_id']?.toString(),
      asignaturaId: json['asignatura_id']?.toString(),
      estadoId: json['estado_id'].toString(),
      creadoEn: DateTime.parse(json['creado_en']),
      modificadoEn: DateTime.parse(json['modificado_en']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docente_id': docenteId,
      'tipo_solicitud': tipoSolicitud,
      'carrera_id': carreraId,
      'asignatura_id': asignaturaId,
      'estado_id': estadoId,
      'creado_en': creadoEn.toIso8601String(),
      'modificado_en': modificadoEn.toIso8601String(),
    };
  }
}
