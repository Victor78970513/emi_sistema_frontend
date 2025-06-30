class Docente {
  final int docenteId;
  final String names;
  final String surnames;
  final String? identificationCard;
  final String? gender;
  final String email;
  final String? docenteImagePath;
  final DateTime? dateOfBirth;
  final int? yearsOfWorkExperience;
  final int? semestersOfTeachingExperience;
  final int? teacherCategoryId;
  final int? entryModeId;
  final int userId;

  Docente({
    required this.docenteId,
    required this.names,
    required this.surnames,
    this.identificationCard,
    this.gender,
    required this.email,
    this.docenteImagePath,
    this.dateOfBirth,
    this.yearsOfWorkExperience,
    this.semestersOfTeachingExperience,
    this.teacherCategoryId,
    this.entryModeId,
    required this.userId,
  });
}
