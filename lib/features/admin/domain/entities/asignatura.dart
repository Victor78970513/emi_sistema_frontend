class Asignatura {
  final String id;
  final String materia;
  final int gestion;
  final String periodo;
  final int sem;
  final String semestres;
  final int cargaHoraria;
  final String? carreraNombre;

  Asignatura({
    required this.id,
    required this.materia,
    required this.gestion,
    required this.periodo,
    required this.sem,
    required this.semestres,
    required this.cargaHoraria,
    this.carreraNombre,
  });
}
