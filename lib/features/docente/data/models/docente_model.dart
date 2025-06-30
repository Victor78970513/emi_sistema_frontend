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
  });

  factory DocenteModel.fromJson(Map<String, dynamic> json) {
    return DocenteModel(
      docenteId: json["docente_id"],
      names: json["nombres"],
      surnames: json["apellidos"],
      identificationCard: json["ci"],
      gender: json["genero"],
      email: json["correo_electronico"],
      docenteImagePath: json["foto_docente"],
      dateOfBirth: json["fecha_nacimiento"],
      yearsOfWorkExperience: json["experiencia_laboral_anios"],
      semestersOfTeachingExperience: json["experiencia_docente_semestres"],
      teacherCategoryId: json["categoria_docente_id"],
      entryModeId: json["modalidad_ingreso_id"],
      userId: json["usuario_id"],
    );
  }
}
