class AsignaturaDisponible {
  final int id;
  final int gestion;
  final String periodo;
  final String materia;
  final int sem;
  final String semestres;
  final int cargaHoraria;
  final String carreraId;
  final DateTime creadoEn;
  final DateTime modificadoEn;
  final String carreraNombre;

  AsignaturaDisponible({
    required this.id,
    required this.gestion,
    required this.periodo,
    required this.materia,
    required this.sem,
    required this.semestres,
    required this.cargaHoraria,
    required this.carreraId,
    required this.creadoEn,
    required this.modificadoEn,
    required this.carreraNombre,
  });
}
