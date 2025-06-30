import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

abstract interface class DocenteRepository {
  Future<Either<Failure, Docente>> getPersonalInfor({required int userId});
}
