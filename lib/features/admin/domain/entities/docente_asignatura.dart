class DocenteAsignatura {
  final String id;
  final String nombres;
  final String apellidos;
  final String correoElectronico;
  final String? fotoDocente;

  DocenteAsignatura({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correoElectronico,
    this.fotoDocente,
  });
}
