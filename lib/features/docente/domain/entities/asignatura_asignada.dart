class AsignaturaAsignada {
  final String id;
  final String docenteId;
  final String asignaturaId;
  final DateTime creadoEn;
  final DateTime modificadoEn;
  final String docenteNombre;
  final String asignaturaNombre;
  final int gestion;
  final String periodo;
  final String semestres;

  AsignaturaAsignada({
    required this.id,
    required this.docenteId,
    required this.asignaturaId,
    required this.creadoEn,
    required this.modificadoEn,
    required this.docenteNombre,
    required this.asignaturaNombre,
    required this.gestion,
    required this.periodo,
    required this.semestres,
  });
}
