class Docente {
  final int docenteId;
  final String names;
  final String surnames;
  final String? carnetIdentidad;
  final String? genero;
  final String? correoElectronico;
  final String? fotoDocente;
  final DateTime? fechaNacimiento;
  final String? experienciaProfesional;
  final String? experienciaAcademica;
  final int? categoriaDocenteId;
  final int? modalidadIngresoId;
  final int userId;
  final String? userNombres;
  final String? userApellidos;
  final String? userCorreo;
  final int rolId;
  final int? carreraId;
  final int? estadoId;
  final String? rolNombre;
  final String? carreraNombre;
  final String? estadoNombre;
  final DateTime? creadoEn;
  final DateTime? modificadoEn;
  final String? categoriaNombre;
  final String? modalidadIngresoNombre;

  Docente({
    required this.docenteId,
    required this.names,
    required this.surnames,
    this.carnetIdentidad,
    this.genero,
    this.correoElectronico,
    this.fotoDocente,
    this.fechaNacimiento,
    this.experienciaProfesional,
    this.experienciaAcademica,
    this.categoriaDocenteId,
    this.modalidadIngresoId,
    required this.userId,
    this.userNombres,
    this.userApellidos,
    this.userCorreo,
    required this.rolId,
    this.carreraId,
    this.estadoId,
    this.rolNombre,
    this.carreraNombre,
    this.estadoNombre,
    this.creadoEn,
    this.modificadoEn,
    this.categoriaNombre,
    this.modalidadIngresoNombre,
  });
}
