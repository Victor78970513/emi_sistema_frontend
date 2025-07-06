import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

class DocenteModel extends Docente {
  DocenteModel({
    required super.docenteId,
    required super.names,
    required super.surnames,
    super.identificationCard,
    super.gender,
    required super.email,
    super.docenteImagePath,
    super.dateOfBirth,
    super.yearsOfWorkExperience,
    super.semestersOfTeachingExperience,
    super.teacherCategoryId,
    super.entryModeId,
    required super.userId,
    super.carreraNombre,
    super.estadoNombre,
  });

  factory DocenteModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateOfBirth(dynamic dateValue) {
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
      identificationCard: json["carnet_identidad"] ?? "",
      gender: json["genero"] ?? "",
      email: json["correo_electronico"] ?? "",
      docenteImagePath: json["foto_docente"] ?? "",
      dateOfBirth: parseDateOfBirth(json["fecha_nacimiento"]),
      yearsOfWorkExperience:
          int.tryParse(json["experiencia_profesional"]?.toString() ?? "0") ?? 0,
      semestersOfTeachingExperience:
          int.tryParse(json["experiencia_academica"]?.toString() ?? "0") ?? 0,
      teacherCategoryId: json["categoria_docente_id"],
      entryModeId: json["modalidad_ingreso_id"],
      userId: int.tryParse(json["usuario_id"]?.toString() ?? "0") ?? 0,
      carreraNombre: json["carrera_nombre"],
      estadoNombre: json["estado_nombre"],
    );
  }
}
