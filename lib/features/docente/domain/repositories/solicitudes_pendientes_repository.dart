import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import '../entities/solicitud_pendiente.dart';

abstract class SolicitudesPendientesRepository {
  Future<Either<Failure, List<SolicitudPendiente>>> getSolicitudesPendientes(
      String token);
}
