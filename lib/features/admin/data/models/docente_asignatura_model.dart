class DocenteAsignaturaModel {
  final String id;
  final String nombres;
  final String apellidos;
  final String correoElectronico;
  final String? fotoDocente;

  DocenteAsignaturaModel({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correoElectronico,
    this.fotoDocente,
  });

  factory DocenteAsignaturaModel.fromJson(Map<String, dynamic> json) {
    return DocenteAsignaturaModel(
      id: json['id'] ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      correoElectronico: json['correo_electronico'] ?? '',
      fotoDocente: json['foto_docente'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo_electronico': correoElectronico,
      'foto_docente': fotoDocente,
    };
  }
}
