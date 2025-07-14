import '../entities/carrera.dart';
import '../entities/asignatura_detalle.dart';
import '../entities/docente_asignatura.dart';
import '../../data/models/asociar_docente_response_model.dart';
import '../../data/models/desasociar_docente_response_model.dart';
import '../../data/models/asociar_docente_request_model.dart';
import '../../data/models/docente_detalle_response_model.dart';
import 'dart:typed_data';

abstract class CarrerasRepository {
  Future<List<Carrera>> getCarreras(String token);
  Future<AsignaturaDetalle> getAsignaturaDetalle(
      String token, String asignaturaId);
  Future<List<DocenteAsignatura>> getDocentesAsignatura(
      String token, String asignaturaId);
  Future<AsociarDocenteResponseModel> asociarDocente(
      String token, String asignaturaId, AsociarDocenteRequestModel request);
  Future<DesasociarDocenteResponseModel> desasociarDocente(
      String token, String asignaturaId, String docenteId);
  Future<DocenteDetalleResponseModel> getDocenteDetalle(
      String token, String docenteId);
  Future<Uint8List> descargarReporteAsignaturas(String token, String carreraId);
}
