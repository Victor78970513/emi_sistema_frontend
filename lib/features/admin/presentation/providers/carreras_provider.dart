import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../data/datasources/carreras_remote_datasource.dart';
import '../../data/repositories/carreras_repository_impl.dart';
import '../../domain/entities/carrera.dart';
import '../../domain/entities/asignatura_detalle.dart';
import '../../domain/entities/docente_asignatura.dart';
import '../../domain/repositories/carreras_repository.dart';
import '../../data/models/asociar_docente_response_model.dart';
import '../../data/models/desasociar_docente_response_model.dart';
import '../../data/models/asociar_docente_request_model.dart';
import '../../data/models/docente_detalle_response_model.dart';
import '../../../docente/presentation/providers/docente_provider.dart';
import '../../../docente/presentation/providers/docente_provider_state.dart';
import 'dart:typed_data';

// Provider para el datasource
final carrerasDataSourceProvider = Provider<CarrerasRemoteDataSource>((ref) {
  return CarrerasRemoteDataSourceImpl(client: http.Client());
});

// Provider para el repositorio
final carrerasRepositoryProvider = Provider<CarrerasRepository>((ref) {
  final dataSource = ref.read(carrerasDataSourceProvider);
  return CarrerasRepositoryImpl(remoteDataSource: dataSource);
});

// Provider para las carreras
final carrerasProvider =
    FutureProvider.family<List<Carrera>, String>((ref, token) async {
  print('DEBUG: Obteniendo carreras con token: $token');
  final repository = ref.read(carrerasRepositoryProvider);
  final carreras = await repository.getCarreras(token);
  print('DEBUG: Carreras obtenidas: ${carreras.length}');
  for (var carrera in carreras) {
    print(
        'DEBUG: Carrera: ${carrera.nombre} con ${carrera.asignaturas.length} asignaturas');
  }
  return carreras;
});

// Provider para detalles de asignatura - usando parámetros separados para evitar recreación
final asignaturaDetalleProvider = FutureProvider.family<AsignaturaDetalle,
    ({String token, String asignaturaId})>((ref, params) async {
  print('DEBUG: Obteniendo detalles de asignatura: ${params.asignaturaId}');
  print('DEBUG: Token: ${params.token}');
  try {
    final repository = ref.read(carrerasRepositoryProvider);
    print('DEBUG: Repository obtenido, llamando a getAsignaturaDetalle');
    final asignaturaDetalle = await repository.getAsignaturaDetalle(
        params.token, params.asignaturaId);
    print('DEBUG: Detalles obtenidos para: ${asignaturaDetalle.materia}');
    return asignaturaDetalle;
  } catch (e) {
    print('DEBUG: Error en asignaturaDetalleProvider: $e');
    rethrow;
  }
});

// Provider para docentes de asignatura - usando parámetros separados para evitar recreación
final docentesAsignaturaProvider = FutureProvider.family<
    List<DocenteAsignatura>,
    ({String token, String asignaturaId})>((ref, params) async {
  print('DEBUG: Obteniendo docentes de asignatura: ${params.asignaturaId}');
  print('DEBUG: Token: ${params.token}');
  try {
    final repository = ref.read(carrerasRepositoryProvider);
    print('DEBUG: Repository obtenido, llamando a getDocentesAsignatura');
    final docentes = await repository.getDocentesAsignatura(
        params.token, params.asignaturaId);
    print('DEBUG: Docentes obtenidos: ${docentes.length}');
    return docentes;
  } catch (e) {
    print('DEBUG: Error en docentesAsignaturaProvider: $e');
    rethrow;
  }
});

// Provider para asociar docente a asignatura
final asociarDocenteProvider = FutureProvider.family<
    AsociarDocenteResponseModel,
    ({
      String token,
      String asignaturaId,
      AsociarDocenteRequestModel request
    })>((ref, params) async {
  print('DEBUG: Asociando docente a asignatura: ${params.asignaturaId}');
  print('DEBUG: Token: ${params.token}');
  try {
    final repository = ref.read(carrerasRepositoryProvider);
    print('DEBUG: Repository obtenido, llamando a asociarDocente');
    final response = await repository.asociarDocente(
        params.token, params.asignaturaId, params.request);
    print('DEBUG: Docente asociado exitosamente');

    // Invalidar el provider de docentes para refrescar la lista
    ref.invalidate(docentesAsignaturaProvider((
      token: params.token,
      asignaturaId: params.asignaturaId,
    )));

    return response;
  } catch (e) {
    print('DEBUG: Error en asociarDocenteProvider: $e');
    rethrow;
  }
});

// Provider para desasociar docente de asignatura
final desasociarDocenteProvider = FutureProvider.family<
    DesasociarDocenteResponseModel,
    ({
      String token,
      String asignaturaId,
      String docenteId
    })>((ref, params) async {
  print('DEBUG: Desasociando docente de asignatura: ${params.asignaturaId}');
  print('DEBUG: Token: ${params.token}');
  print('DEBUG: Docente ID: ${params.docenteId}');
  try {
    final repository = ref.read(carrerasRepositoryProvider);
    print('DEBUG: Repository obtenido, llamando a desasociarDocente');
    final response = await repository.desasociarDocente(
        params.token, params.asignaturaId, params.docenteId);
    print('DEBUG: Docente desasociado exitosamente');

    // Invalidar el provider de docentes para refrescar la lista
    ref.invalidate(docentesAsignaturaProvider((
      token: params.token,
      asignaturaId: params.asignaturaId,
    )));

    return response;
  } catch (e) {
    print('DEBUG: Error en desasociarDocenteProvider: $e');
    rethrow;
  }
});

// Provider para obtener todos los docentes disponibles
final docentesDisponiblesProvider =
    FutureProvider.family<List<dynamic>, String>((ref, token) async {
  print('DEBUG: Obteniendo docentes disponibles con token: $token');
  try {
    // Usar el provider existente de docentes
    final docenteState = ref.read(docenteProvider);
    if (docenteState is DocenteSuccessState && docenteState.docentes != null) {
      print(
          'DEBUG: Docentes disponibles obtenidos: ${docenteState.docentes!.length}');
      return docenteState.docentes!;
    } else {
      // Si no hay docentes cargados, cargarlos
      await ref.read(docenteProvider.notifier).getAllDocentes();
      final newState = ref.read(docenteProvider);
      if (newState is DocenteSuccessState && newState.docentes != null) {
        print('DEBUG: Docentes cargados: ${newState.docentes!.length}');
        return newState.docentes!;
      }
      return [];
    }
  } catch (e) {
    print('DEBUG: Error en docentesDisponiblesProvider: $e');
    return [];
  }
});

// Provider para obtener detalles del docente
final docenteDetalleProvider = FutureProvider.family<
    DocenteDetalleResponseModel,
    ({String token, String docenteId})>((ref, params) async {
  print('DEBUG: Obteniendo detalles del docente: ${params.docenteId}');
  print('DEBUG: Token: ${params.token}');
  try {
    final repository = ref.read(carrerasRepositoryProvider);
    print('DEBUG: Repository obtenido, llamando a getDocenteDetalle');
    final response =
        await repository.getDocenteDetalle(params.token, params.docenteId);
    print('DEBUG: Detalles del docente obtenidos exitosamente');
    return response;
  } catch (e) {
    print('DEBUG: Error en docenteDetalleProvider: $e');
    rethrow;
  }
});

// Provider para descargar reporte PDF de asignaturas
final descargarReporteAsignaturasProvider =
    FutureProvider.family<Uint8List, Map<String, String>>((ref, params) async {
  final repository = ref.read(carrerasRepositoryProvider);
  final token = params['token']!;
  final carreraId = params['carreraId']!;
  return await repository.descargarReporteAsignaturas(token, carreraId);
});
