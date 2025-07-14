import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import '../../domain/entities/solicitud_pendiente.dart';
import '../../domain/repositories/solicitudes_pendientes_repository.dart';
import '../datasources/solicitudes_pendientes_datasource.dart';

class SolicitudesPendientesRepositoryImpl
    implements SolicitudesPendientesRepository {
  final SolicitudesPendientesDatasource datasource;

  SolicitudesPendientesRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<SolicitudPendiente>>> getSolicitudesPendientes(
      String token) async {
    try {
      final solicitudes = await datasource.getSolicitudesPendientes(token);
      return right(solicitudes);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
