class AsignaturaModel {
  final String id;
  final String materia;
  final int gestion;
  final String periodo;
  final int sem;
  final String semestres;
  final int cargaHoraria;
  final double? horasSemanales;
  final String? carreraNombre;

  AsignaturaModel({
    required this.id,
    required this.materia,
    required this.gestion,
    required this.periodo,
    required this.sem,
    required this.semestres,
    required this.cargaHoraria,
    this.horasSemanales,
    this.carreraNombre,
  });

  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      id: json['id'] ?? '',
      materia: json['asignatura_nombre'] ?? json['materia'] ?? '',
      gestion: json['gestion'] ?? 0,
      periodo: json['periodo'] ?? '',
      sem: json['sem'] ?? 0,
      semestres: json['semestres'] ?? '',
      cargaHoraria: json['carga_horaria'] ?? 0,
      horasSemanales: (json['horas_semanales'] as num?)?.toDouble(),
      carreraNombre: json['carrera_nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materia': materia,
      'gestion': gestion,
      'periodo': periodo,
      'sem': sem,
      'semestres': semestres,
      'carga_horaria': cargaHoraria,
      'horas_semanales': horasSemanales,
      'carrera_nombre': carreraNombre,
    };
  }
}
