import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/solicitud_admin.dart';
import '../providers/solicitudes_loading_provider.dart';

class SolicitudCardWidget extends ConsumerWidget {
  final SolicitudAdmin solicitud;
  final bool isDesktop;
  final VoidCallback onAprobar;
  final VoidCallback onRechazar;

  const SolicitudCardWidget({
    super.key,
    required this.solicitud,
    required this.isDesktop,
    required this.onAprobar,
    required this.onRechazar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadingState = ref.watch(solicitudesLoadingProvider);
    final solicitudId = solicitud.id.toString();
    final isApproving = loadingState[solicitudId] == 'approving';
    final isRejecting = loadingState[solicitudId] == 'rejecting';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xff2350ba).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 6),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono, tipo y estado
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getIconColor(solicitud.tipoSolicitud),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _getIconColor(solicitud.tipoSolicitud)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIcon(solicitud.tipoSolicitud),
                    color: Colors.white,
                    size: isDesktop ? 24 : 20,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        solicitud.tipoSolicitud == 'carrera'
                            ? 'Solicitud de Carrera'
                            : 'Solicitud de Asignatura',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2350ba),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Docente: ${solicitud.docenteNombre} ${solicitud.docenteApellidos}',
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(solicitud.estadoNombre),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(solicitud.estadoNombre)
                            .withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    solicitud.estadoNombre.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isDesktop ? 12 : 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Información de la solicitud
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xff2350ba),
                        size: isDesktop ? 20 : 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Detalles de la Solicitud',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2350ba),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solicita:',
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              solicitud.tipoSolicitud == 'carrera'
                                  ? solicitud.carreraNombre ??
                                      'Carrera no especificada'
                                  : solicitud.asignaturaNombre ??
                                      'Asignatura no especificada',
                              style: TextStyle(
                                fontSize: isDesktop ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff374151),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Fecha de Solicitud:',
                            style: TextStyle(
                              fontSize: isDesktop ? 12 : 10,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatDate(solicitud.creadoEn),
                            style: TextStyle(
                              fontSize: isDesktop ? 12 : 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        (solicitud.estadoNombre.toLowerCase() == 'pendiente' &&
                                !isApproving &&
                                !isRejecting)
                            ? onAprobar
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2350ba),
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: isDesktop ? 16 : 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                    child: isApproving
                        ? SizedBox(
                            width: isDesktop ? 20 : 18,
                            height: isDesktop ? 20 : 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: isDesktop ? 20 : 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Aprobar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isDesktop ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        (solicitud.estadoNombre.toLowerCase() == 'pendiente' &&
                                !isApproving &&
                                !isRejecting)
                            ? onRechazar
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: isDesktop ? 16 : 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      disabledBackgroundColor: Colors.grey[300],
                      disabledForegroundColor: Colors.grey[600],
                    ),
                    child: isRejecting
                        ? SizedBox(
                            width: isDesktop ? 20 : 18,
                            height: isDesktop ? 20 : 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                color: Colors.white,
                                size: isDesktop ? 20 : 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Rechazar',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: isDesktop ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'carrera':
        return Color(0xff2350ba);
      case 'asignatura':
        return Color(0xff374151);
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'carrera':
        return Icons.school;
      case 'asignatura':
        return Icons.book;
      default:
        return Icons.assignment;
    }
  }

  Color _getStatusColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'aprobado':
        return Colors.green;
      case 'rechazado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
