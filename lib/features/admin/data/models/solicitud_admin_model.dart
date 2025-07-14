import '../../domain/entities/solicitud_admin.dart';

class SolicitudAdminModel extends SolicitudAdmin {
  SolicitudAdminModel({
    required super.id,
    required super.docenteId,
    required super.tipoSolicitud,
    super.carreraId,
    super.asignaturaId,
    required super.estadoId,
    required super.creadoEn,
    required super.modificadoEn,
    required super.docenteNombre,
    required super.docenteApellidos,
    super.carreraNombre,
    super.asignaturaNombre,
    required super.estadoNombre,
  });

  factory SolicitudAdminModel.fromJson(Map<String, dynamic> json) {
    return SolicitudAdminModel(
      id: json['id'] ?? '',
      docenteId: json['docente_id'] ?? '',
      tipoSolicitud: json['tipo_solicitud'] ?? '',
      carreraId: json['carrera_id'],
      asignaturaId: json['asignatura_id'],
      estadoId: json['estado_id'] ?? '',
      creadoEn:
          DateTime.parse(json['creado_en'] ?? DateTime.now().toIso8601String()),
      modificadoEn: DateTime.parse(
          json['modificado_en'] ?? DateTime.now().toIso8601String()),
      docenteNombre: json['docente_nombre'] ?? '',
      docenteApellidos: json['docente_apellidos'] ?? '',
      carreraNombre: json['carrera_nombre'],
      asignaturaNombre: json['asignatura_nombre'],
      estadoNombre: json['estado_nombre'] ?? '',
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
      'docente_nombre': docenteNombre,
      'docente_apellidos': docenteApellidos,
      'carrera_nombre': carreraNombre,
      'asignatura_nombre': asignaturaNombre,
      'estado_nombre': estadoNombre,
    };
  }
}
