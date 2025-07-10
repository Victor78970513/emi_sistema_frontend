import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

class DocenteModel extends Docente {
  DocenteModel({
    required super.docenteId,
    required super.names,
    required super.surnames,
    super.carnetIdentidad,
    super.genero,
    super.correoElectronico,
    super.fotoDocente,
    super.fechaNacimiento,
    super.experienciaProfesional,
    super.experienciaAcademica,
    super.categoriaDocenteId,
    super.modalidadIngresoId,
    required super.userId,
    super.userNombres,
    super.userApellidos,
    super.userCorreo,
    required super.rolId,
    super.carreraId,
    super.estadoId,
    super.rolNombre,
    super.carreraNombre,
    super.estadoNombre,
    super.creadoEn,
    super.modificadoEn,
    super.categoriaNombre,
    super.modalidadIngresoNombre,
  });

  factory DocenteModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic dateValue) {
      if (dateValue == null || dateValue.toString().isEmpty) {
        return null;
      }
      try {
        return DateTime.parse(dateValue.toString());
      } catch (e) {
        print('Error parsing date: $dateValue - $e');
        return null;
      }
    }

    return DocenteModel(
      docenteId: int.tryParse(json["docente_id"]?.toString() ?? "0") ?? 0,
      names: json["nombres"] ?? "",
      surnames: json["apellidos"] ?? "",
      carnetIdentidad: json["carnet_identidad"]?.toString() ?? "",
      genero: json["genero"]?.toString() ?? "",
      correoElectronico: json["correo_electronico"]?.toString() ?? "",
      fotoDocente: json["foto_docente"]?.toString() ?? "",
      fechaNacimiento: parseDateTime(json["fecha_nacimiento"]),
      experienciaProfesional: json["experiencia_profesional"]?.toString() ?? "",
      experienciaAcademica: json["experiencia_academica"]?.toString() ?? "",
      categoriaDocenteId:
          int.tryParse(json["categoria_docente_id"]?.toString() ?? "0"),
      modalidadIngresoId:
          int.tryParse(json["modalidad_ingreso_id"]?.toString() ?? "0"),
      userId: int.tryParse(json["usuario_id"]?.toString() ?? "0") ?? 0,
      userNombres: json["user_nombres"]?.toString() ?? "",
      userApellidos: json["user_apellidos"]?.toString() ?? "",
      userCorreo: json["user_correo"]?.toString() ?? "",
      rolId: int.tryParse(json["rol_id"]?.toString() ?? "0") ?? 0,
      carreraId: int.tryParse(json["carrera_id"]?.toString() ?? "0"),
      estadoId: int.tryParse(json["estado_id"]?.toString() ?? "0"),
      rolNombre: json["rol_nombre"]?.toString() ?? "",
      carreraNombre: json["carrera_nombre"]?.toString() ?? "",
      estadoNombre: json["estado_nombre"]?.toString() ?? "",
      creadoEn: parseDateTime(json["creado_en"]),
      modificadoEn: parseDateTime(json["modificado_en"]),
      categoriaNombre: json["categoria_nombre"]?.toString() ?? "",
      modalidadIngresoNombre:
          json["modalidad_ingreso_nombre"]?.toString() ?? "",
    );
  }
}
