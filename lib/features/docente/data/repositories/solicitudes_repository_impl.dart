import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import '../../domain/entities/solicitud.dart';
import '../../domain/repositories/solicitudes_repository.dart';
import '../datasources/solicitudes_datasource.dart';

class SolicitudesRepositoryImpl implements SolicitudesRepository {
  final SolicitudesDatasource datasource;

  SolicitudesRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, Solicitud>> crearSolicitud(
      String token, String tipoSolicitud, int id) async {
    try {
      final solicitud =
          await datasource.crearSolicitud(token, tipoSolicitud, id);
      return right(solicitud);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
