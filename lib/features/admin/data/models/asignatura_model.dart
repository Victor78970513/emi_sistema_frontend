class AsignaturaModel {
  final String id;
  final String materia;
  final int gestion;
  final String periodo;
  final int sem;
  final String semestres;
  final int cargaHoraria;

  AsignaturaModel({
    required this.id,
    required this.materia,
    required this.gestion,
    required this.periodo,
    required this.sem,
    required this.semestres,
    required this.cargaHoraria,
  });

  factory AsignaturaModel.fromJson(Map<String, dynamic> json) {
    return AsignaturaModel(
      id: json['id'] ?? '',
      materia: json['materia'] ?? '',
      gestion: json['gestion'] ?? 0,
      periodo: json['periodo'] ?? '',
      sem: json['sem'] ?? 0,
      semestres: json['semestres'] ?? '',
      cargaHoraria: json['carga_horaria'] ?? 0,
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
    };
  }
}
