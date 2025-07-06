import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';

abstract interface class DocenteRepository {
  Future<Either<Failure, Docente>> getPersonalInfor({required int userId});
  Future<Either<Failure, List<CarreraModel>>> getCarreras();
}
