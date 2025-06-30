import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  final DocenteRemoteDatasource docenteDatasource;

  DocenteRepositoryImpl({required this.docenteDatasource});
  @override
  Future<Either<Failure, Docente>> getPersonalInfor(
      {required int userId}) async {
    try {
      final response = await docenteDatasource.getPersonalInfor(userId: userId);
      return right(response);
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
