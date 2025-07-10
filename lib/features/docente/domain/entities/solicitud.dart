class Solicitud {
  final String id;
  final String docenteId;
  final String tipoSolicitud;
  final String? carreraId;
  final String? asignaturaId;
  final String estadoId;
  final DateTime creadoEn;
  final DateTime modificadoEn;

  Solicitud({
    required this.id,
    required this.docenteId,
    required this.tipoSolicitud,
    this.carreraId,
    this.asignaturaId,
    required this.estadoId,
    required this.creadoEn,
    required this.modificadoEn,
  });
}
