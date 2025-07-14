import '../../domain/entities/carrera.dart';
import '../../domain/entities/asignatura_detalle.dart';
import '../../domain/entities/docente_asignatura.dart';
import '../../domain/repositories/carreras_repository.dart';
import '../datasources/carreras_remote_datasource.dart';
import '../mappers/carrera_mapper.dart';
import '../mappers/asignatura_detalle_mapper.dart';
import '../mappers/docente_asignatura_mapper.dart';
import '../models/asociar_docente_response_model.dart';
import '../models/desasociar_docente_response_model.dart';
import '../models/asociar_docente_request_model.dart';
import '../models/docente_detalle_response_model.dart';
import 'dart:typed_data';

class CarrerasRepositoryImpl implements CarrerasRepository {
  final CarrerasRemoteDataSource remoteDataSource;

  CarrerasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Carrera>> getCarreras(String token) async {
    try {
      final carrerasResponse = await remoteDataSource.getCarreras(token);
      return CarreraMapper.fromModelList(carrerasResponse.carreras);
    } catch (e) {
      throw Exception('Error al obtener carreras: $e');
    }
  }

  @override
  Future<AsignaturaDetalle> getAsignaturaDetalle(
      String token, String asignaturaId) async {
    try {
      final asignaturaDetalleModel =
          await remoteDataSource.getAsignaturaDetalle(token, asignaturaId);
      return AsignaturaDetalleMapper.fromModel(asignaturaDetalleModel);
    } catch (e) {
      throw Exception('Error al obtener detalles de asignatura: $e');
    }
  }

  @override
  Future<List<DocenteAsignatura>> getDocentesAsignatura(
      String token, String asignaturaId) async {
    try {
      final docentesResponse =
          await remoteDataSource.getDocentesAsignatura(token, asignaturaId);
      return DocenteAsignaturaMapper.fromModelList(docentesResponse.docentes);
    } catch (e) {
      throw Exception('Error al obtener docentes de asignatura: $e');
    }
  }

  @override
  Future<AsociarDocenteResponseModel> asociarDocente(String token,
      String asignaturaId, AsociarDocenteRequestModel request) async {
    try {
      return await remoteDataSource.asociarDocente(
          token, asignaturaId, request);
    } catch (e) {
      throw Exception('Error al asociar docente a asignatura: $e');
    }
  }

  @override
  Future<DesasociarDocenteResponseModel> desasociarDocente(
      String token, String asignaturaId, String docenteId) async {
    try {
      return await remoteDataSource.desasociarDocente(
          token, asignaturaId, docenteId);
    } catch (e) {
      throw Exception('Error al desasociar docente de asignatura: $e');
    }
  }

  @override
  Future<DocenteDetalleResponseModel> getDocenteDetalle(
      String token, String docenteId) async {
    try {
      return await remoteDataSource.getDocenteDetalle(token, docenteId);
    } catch (e) {
      throw Exception('Error al obtener detalles del docente: $e');
    }
  }

  @override
  Future<Uint8List> descargarReporteAsignaturas(
      String token, String carreraId) async {
    try {
      return await remoteDataSource.descargarReporteAsignaturas(
          token, carreraId);
    } catch (e) {
      throw Exception('Error al descargar reporte de asignaturas: $e');
    }
  }
}
