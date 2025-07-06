class EstudioAcademicoModel {
  final String id;
  final String docenteId;
  final String titulo;
  final String documentoUrl;
  final String institucionId;
  final String gradoAcademicoId;
  final String creadoEn;
  final String modificadoEn;
  final int anioTitulacion;
  final String institucionNombre;
  final String gradoAcademicoNombre;

  EstudioAcademicoModel({
    required this.id,
    required this.docenteId,
    required this.titulo,
    required this.documentoUrl,
    required this.institucionId,
    required this.gradoAcademicoId,
    required this.creadoEn,
    required this.modificadoEn,
    required this.anioTitulacion,
    required this.institucionNombre,
    required this.gradoAcademicoNombre,
  });

  factory EstudioAcademicoModel.fromJson(Map<String, dynamic> json) {
    return EstudioAcademicoModel(
      id: json['id'] ?? '',
      docenteId: json['docente_id'] ?? '',
      titulo: json['titulo'] ?? '',
      documentoUrl: json['documento_url'] ?? '',
      institucionId: json['institucion_id'] ?? '',
      gradoAcademicoId: json['grado_academico_id'] ?? '',
      creadoEn: json['creado_en'] ?? '',
      modificadoEn: json['modificado_en'] ?? '',
      anioTitulacion: json['año_titulacion'] ?? 0,
      institucionNombre: json['institucion_nombre'] ?? '',
      gradoAcademicoNombre: json['grado_academico_nombre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docente_id': docenteId,
      'titulo': titulo,
      'documento_url': documentoUrl,
      'institucion_id': institucionId,
      'grado_academico_id': gradoAcademicoId,
      'creado_en': creadoEn,
      'modificado_en': modificadoEn,
      'año_titulacion': anioTitulacion,
      'institucion_nombre': institucionNombre,
      'grado_academico_nombre': gradoAcademicoNombre,
    };
  }
}
