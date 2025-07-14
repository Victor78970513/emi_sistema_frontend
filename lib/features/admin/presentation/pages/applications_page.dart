import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/solicitudes_admin_provider.dart';
import '../providers/solicitudes_actions_provider.dart';
import '../providers/admin_data_provider.dart';
import '../providers/solicitudes_loading_provider.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../widgets/solicitud_card_widget.dart';
import '../widgets/reject_dialog.dart';

class ApplicationsPage extends ConsumerWidget {
  const ApplicationsPage({super.key});

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el token de manera asíncrona
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, tokenSnapshot) {
        if (tokenSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (tokenSnapshot.data == null) {
          return Center(
            child: Text('Error: No se pudo obtener el token'),
          );
        }

        final token = tokenSnapshot.data!;
        final solicitudesAsync = ref.watch(solicitudesAdminProvider(token));

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 1024;

            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header elegante
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: isDesktop ? 24 : 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff2350ba).withValues(alpha: 0.1),
                          Color(0xff2350ba).withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xff2350ba).withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 20,
                      vertical: isDesktop ? 24 : 16,
                    ),
                    child: isDesktop
                        ? Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xff2350ba),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.assignment,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gestión de Solicitudes",
                                      style: TextStyle(
                                        color: Color(0xff2350ba),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Revisa y gestiona las solicitudes de carreras y asignaturas",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xff2350ba),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Gestión de Solicitudes",
                                      style: TextStyle(
                                        color: Color(0xff2350ba),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Revisa y gestiona las solicitudes de carreras y asignaturas",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: isDesktop ? 25 : 12),

                  // Contenido principal
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 24 : 16,
                      ),
                      child: solicitudesAsync.when(
                        data: (solicitudes) => solicitudes.isEmpty
                            ? _buildEmptyState()
                            : _buildSolicitudesList(
                                solicitudes, isDesktop, token, ref),
                        loading: () => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff2350ba)),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Cargando solicitudes...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        error: (error, stack) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Error al cargar solicitudes',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                error.toString(),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: Colors.grey[400],
              size: 48,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'No hay solicitudes pendientes',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Todas las solicitudes han sido procesadas',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesList(List<SolicitudAdmin> solicitudes, bool isDesktop,
      String token, WidgetRef ref) {
    return ListView.builder(
      itemCount: solicitudes.length,
      itemBuilder: (context, index) {
        final solicitud = solicitudes[index];
        return SolicitudCardWidget(
          solicitud: solicitud,
          isDesktop: isDesktop,
          onAprobar: () => _aprobarSolicitud(context, solicitud, token, ref),
          onRechazar: () => _rechazarSolicitud(context, solicitud, token, ref),
        );
      },
    );
  }

  void _aprobarSolicitud(BuildContext context, SolicitudAdmin solicitud,
      String token, WidgetRef ref) {
    final solicitudId = solicitud.id.toString();

    // Activar loading para esta solicitud
    ref
        .read(solicitudesLoadingProvider.notifier)
        .setLoading(solicitudId, 'approving');

    // Ejecutar la acción con delay para ver el loading
    Future.delayed(Duration(seconds: 2), () {
      ref
          .read(solicitudesActionsProvider.notifier)
          .aprobarSolicitud(token, solicitudId)
          .then((_) {
        // Desactivar loading
        ref.read(solicitudesLoadingProvider.notifier).clearLoading(solicitudId);

        // Obtener el estado actual
        final actionsState = ref.read(solicitudesActionsProvider);

        if (actionsState.error != null) {
          // Solo mostrar error en consola, no SnackBar
          print('Error al aprobar solicitud: ${actionsState.error}');
        } else if (actionsState.successMessage != null) {
          print('Acción exitosa, recargando datos...');
          // Recargar todos los datos del admin
          Future(() {
            ref.read(adminDataProvider.notifier).refreshAllData();
          });
        }
      });
    });
  }

  void _rechazarSolicitud(BuildContext context, SolicitudAdmin solicitud,
      String token, WidgetRef ref) {
    // Mostrar diálogo para pedir razón del rechazo
    showDialog(
      context: context,
      builder: (dialogContext) => RejectDialog(
        userName: '${solicitud.docenteNombre} ${solicitud.docenteApellidos}',
        onReject: (String reason) async {
          final solicitudId = solicitud.id.toString();

          // Activar loading para esta solicitud
          ref
              .read(solicitudesLoadingProvider.notifier)
              .setLoading(solicitudId, 'rejecting');

          try {
            // Ejecutar la acción con delay para ver el loading
            await Future.delayed(Duration(seconds: 2), () async {
              await ref
                  .read(solicitudesActionsProvider.notifier)
                  .rechazarSolicitud(token, solicitudId, reason);
            });

            // Desactivar loading
            ref
                .read(solicitudesLoadingProvider.notifier)
                .clearLoading(solicitudId);

            // Obtener el estado actual
            final actionsState = ref.read(solicitudesActionsProvider);

            if (actionsState.error != null) {
              // Solo mostrar error en consola, no SnackBar
              print('Error al rechazar solicitud: ${actionsState.error}');
            } else if (actionsState.successMessage != null) {
              print('Acción exitosa, recargando datos...');
              // Recargar todos los datos del admin
              Future(() {
                ref.read(adminDataProvider.notifier).refreshAllData();
              });
            }
          } catch (e) {
            // Desactivar loading en caso de error
            ref
                .read(solicitudesLoadingProvider.notifier)
                .clearLoading(solicitudId);
            print('Error al rechazar solicitud: $e');
          }
        },
      ),
    );
  }
}
