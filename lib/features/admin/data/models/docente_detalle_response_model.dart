class DocenteDetalleResponseModel {
  final String message;
  final DocenteDetalleDataModel data;

  DocenteDetalleResponseModel({
    required this.message,
    required this.data,
  });

  factory DocenteDetalleResponseModel.fromJson(Map<String, dynamic> json) {
    return DocenteDetalleResponseModel(
      message: json['message'] ?? '',
      data: DocenteDetalleDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DocenteDetalleDataModel {
  final String docenteId;
  final String nombres;
  final String apellidos;
  final String? carnetIdentidad;
  final String? genero;
  final String? correoElectronico;
  final String? fotoDocente;
  final DateTime? fechaNacimiento;
  final String? experienciaProfesional;
  final String? experienciaAcademica;
  final int? categoriaDocenteId;
  final int? modalidadIngresoId;
  final String usuarioId;
  final String? userNombres;
  final String? userApellidos;
  final String? userCorreo;
  final String rolId;
  final String? carreraId;
  final String? estadoId;
  final String? rolNombre;
  final String? carreraNombre;
  final String? estadoNombre;
  final DateTime? creadoEn;
  final DateTime? modificadoEn;
  final String? categoriaNombre;
  final String? modalidadIngresoNombre;

  DocenteDetalleDataModel({
    required this.docenteId,
    required this.nombres,
    required this.apellidos,
    this.carnetIdentidad,
    this.genero,
    this.correoElectronico,
    this.fotoDocente,
    this.fechaNacimiento,
    this.experienciaProfesional,
    this.experienciaAcademica,
    this.categoriaDocenteId,
    this.modalidadIngresoId,
    required this.usuarioId,
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

  factory DocenteDetalleDataModel.fromJson(Map<String, dynamic> json) {
    return DocenteDetalleDataModel(
      docenteId: json['docente_id']?.toString() ?? '',
      nombres: json['nombres'] ?? '',
      apellidos: json['apellidos'] ?? '',
      carnetIdentidad: json['carnet_identidad'],
      genero: json['genero'],
      correoElectronico: json['correo_electronico'],
      fotoDocente: json['foto_docente'],
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'])
          : null,
      experienciaProfesional: json['experiencia_profesional'],
      experienciaAcademica: json['experiencia_academica'],
      categoriaDocenteId: json['categoria_docente_id'],
      modalidadIngresoId: json['modalidad_ingreso_id'],
      usuarioId: json['usuario_id']?.toString() ?? '',
      userNombres: json['user_nombres'],
      userApellidos: json['user_apellidos'],
      userCorreo: json['user_correo'],
      rolId: json['rol_id']?.toString() ?? '',
      carreraId: json['carrera_id']?.toString(),
      estadoId: json['estado_id']?.toString(),
      rolNombre: json['rol_nombre'],
      carreraNombre: json['carrera_nombre'],
      estadoNombre: json['estado_nombre'],
      creadoEn:
          json['creado_en'] != null ? DateTime.parse(json['creado_en']) : null,
      modificadoEn: json['modificado_en'] != null
          ? DateTime.parse(json['modificado_en'])
          : null,
      categoriaNombre: json['categoria_nombre'],
      modalidadIngresoNombre: json['modalidad_ingreso_nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docente_id': docenteId,
      'nombres': nombres,
      'apellidos': apellidos,
      'carnet_identidad': carnetIdentidad,
      'genero': genero,
      'correo_electronico': correoElectronico,
      'foto_docente': fotoDocente,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'experiencia_profesional': experienciaProfesional,
      'experiencia_academica': experienciaAcademica,
      'categoria_docente_id': categoriaDocenteId,
      'modalidad_ingreso_id': modalidadIngresoId,
      'usuario_id': usuarioId,
      'user_nombres': userNombres,
      'user_apellidos': userApellidos,
      'user_correo': userCorreo,
      'rol_id': rolId,
      'carrera_id': carreraId,
      'estado_id': estadoId,
      'rol_nombre': rolNombre,
      'carrera_nombre': carreraNombre,
      'estado_nombre': estadoNombre,
      'creado_en': creadoEn?.toIso8601String(),
      'modificado_en': modificadoEn?.toIso8601String(),
      'categoria_nombre': categoriaNombre,
      'modalidad_ingreso_nombre': modalidadIngresoNombre,
    };
  }
}
