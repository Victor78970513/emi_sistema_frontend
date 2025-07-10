import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../../data/datasources/solicitudes_admin_remote_datasource.dart';
import '../../data/repositories/solicitudes_admin_repository_impl.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../../domain/repositories/solicitudes_admin_repository.dart';

// Provider para el datasource
final solicitudesAdminDataSourceProvider =
    Provider<SolicitudesAdminRemoteDataSource>((ref) {
  return SolicitudesAdminRemoteDataSourceImpl(client: http.Client());
});

// Provider para el repositorio
final solicitudesAdminRepositoryProvider =
    Provider<SolicitudesAdminRepository>((ref) {
  final dataSource = ref.watch(solicitudesAdminDataSourceProvider);
  return SolicitudesAdminRepositoryImpl(remoteDataSource: dataSource);
});

// Provider para las solicitudes
final solicitudesAdminProvider =
    FutureProvider.family<List<SolicitudAdmin>, String>((ref, token) async {
  final repository = ref.watch(solicitudesAdminRepositoryProvider);
  return await repository.getSolicitudes(token);
});
