import '../../domain/entities/solicitud_pendiente.dart';

class SolicitudPendienteModel extends SolicitudPendiente {
  SolicitudPendienteModel({
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

  factory SolicitudPendienteModel.fromJson(Map<String, dynamic> json) {
    return SolicitudPendienteModel(
      id: json['id'].toString(),
      docenteId: json['docente_id'].toString(),
      tipoSolicitud: json['tipo_solicitud'],
      carreraId: json['carrera_id']?.toString(),
      asignaturaId: json['asignatura_id']?.toString(),
      estadoId: json['estado_id'].toString(),
      creadoEn: DateTime.parse(json['creado_en']),
      modificadoEn: DateTime.parse(json['modificado_en']),
      docenteNombre: json['docente_nombre'],
      docenteApellidos: json['docente_apellidos'] ?? '',
      carreraNombre: json['carrera_nombre'],
      asignaturaNombre: json['asignatura_nombre'],
      estadoNombre: json['estado_nombre'],
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
