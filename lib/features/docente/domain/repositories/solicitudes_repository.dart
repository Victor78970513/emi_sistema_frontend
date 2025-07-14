import 'package:dartz/dartz.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import '../entities/solicitud.dart';

abstract class SolicitudesRepository {
  Future<Either<Failure, Solicitud>> crearSolicitud(
      String token, String tipoSolicitud, int id);
}
