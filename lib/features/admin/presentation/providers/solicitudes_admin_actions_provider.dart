import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/solicitudes_admin_repository_impl.dart';
import '../../data/datasources/solicitudes_admin_remote_datasource.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

// Provider para el datasource
final solicitudesAdminActionsDataSourceProvider =
    Provider<SolicitudesAdminRemoteDataSource>((ref) {
  return SolicitudesAdminRemoteDataSourceImpl(client: http.Client());
});

// Provider para el repositorio
final solicitudesAdminActionsRepositoryProvider =
    Provider<SolicitudesAdminRepositoryImpl>((ref) {
  final dataSource = ref.read(solicitudesAdminActionsDataSourceProvider);
  return SolicitudesAdminRepositoryImpl(remoteDataSource: dataSource);
});

// Provider para aprobar solicitud
final aprobarSolicitudProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, String>>(
        (ref, params) async {
  final repository = ref.read(solicitudesAdminActionsRepositoryProvider);
  final token = params['token']!;
  final solicitudId = params['solicitudId']!;
  return await repository.aprobarSolicitud(token, solicitudId);
});

// Provider para rechazar solicitud
final rechazarSolicitudProvider =
    FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final repository = ref.read(solicitudesAdminActionsRepositoryProvider);
  final token = params['token']!;
  final solicitudId = params['solicitudId']!;
  final reason = params['reason']!;
  return await repository.rechazarSolicitud(token, solicitudId, reason);
});
