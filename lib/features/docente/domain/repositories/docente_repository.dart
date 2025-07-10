import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';

abstract interface class DocenteRepository {
  Future<Either<Failure, Docente>> getPersonalInfor();
  Future<Either<Failure, List<CarreraModel>>> getCarreras();
  Future<Either<Failure, List<Docente>>> getAllDocentes();
  Future<Either<Failure, List<EstudioAcademicoModel>>> getEstudiosAcademicos(
      {required int docenteId});
  Future<Either<Failure, Docente>> updateDocenteProfile(
      Map<String, dynamic> profileData);
  Future<Either<Failure, Docente>> uploadDocentePhoto(dynamic photoFile);
}
