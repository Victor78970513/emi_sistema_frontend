class SolicitudPendiente {
  final String id;
  final String docenteId;
  final String tipoSolicitud;
  final String? carreraId;
  final String? asignaturaId;
  final String estadoId;
  final DateTime creadoEn;
  final DateTime modificadoEn;
  final String docenteNombre;
  final String docenteApellidos;
  final String? carreraNombre;
  final String? asignaturaNombre;
  final String estadoNombre;

  SolicitudPendiente({
    required this.id,
    required this.docenteId,
    required this.tipoSolicitud,
    this.carreraId,
    this.asignaturaId,
    required this.estadoId,
    required this.creadoEn,
    required this.modificadoEn,
    required this.docenteNombre,
    required this.docenteApellidos,
    this.carreraNombre,
    this.asignaturaNombre,
    required this.estadoNombre,
  });
}
