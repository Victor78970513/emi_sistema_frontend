import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/docente_asignatura.dart';
import '../providers/carreras_provider.dart';
import '../../../../core/preferences/preferences.dart';
import 'desasociar_docente_button.dart';
import 'asociar_docente_dialog.dart';
import 'ver_docente_info_button.dart';

class AsignaturaDetallePanel extends ConsumerWidget {
  final String asignaturaId;
  final bool isDesktop;

  const AsignaturaDetallePanel({
    super.key,
    required this.asignaturaId,
    this.isDesktop = false,
  });

  void _showAsociarDocenteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AsociarDocenteDialog(
        asignaturaId: asignaturaId,
        onSuccess: () {
          // El provider se refrescará automáticamente
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(
        'DEBUG: AsignaturaDetallePanel - Construyendo para asignaturaId: $asignaturaId');

    final token = Preferences().userToken;
    print('DEBUG: AsignaturaDetallePanel - Token: $token');

    if (token.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(
                'Error: No hay token de autenticación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
        ),
      );
    }

    final asignaturaDetalleAsync = ref.watch(asignaturaDetalleProvider((
      token: token,
      asignaturaId: asignaturaId,
    )));

    return asignaturaDetalleAsync.when(
      loading: () {
        print('DEBUG: AsignaturaDetallePanel - Estado: LOADING');
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Cargando detalles de la asignatura...'),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        print('DEBUG: AsignaturaDetallePanel - Estado: ERROR - $error');
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                SizedBox(height: 16),
                Text(
                  'Error al cargar los detalles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
      data: (asignaturaDetalle) {
        print(
            'DEBUG: AsignaturaDetallePanel - Estado: DATA - ${asignaturaDetalle.materia}');
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xff2350ba).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff2350ba).withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xff2350ba).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.book,
                        color: Color(0xff2350ba),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asignaturaDetalle.materia,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2350ba),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            asignaturaDetalle.carrera.nombre,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Contenido
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información de la asignatura
                      _buildInfoSection(
                        title: 'Información de la Asignatura',
                        children: [
                          _buildInfoRow(
                              'Gestión', '${asignaturaDetalle.gestion}'),
                          _buildInfoRow('Período', asignaturaDetalle.periodo),
                          _buildInfoRow(
                              'Semestre', asignaturaDetalle.semestres),
                          _buildInfoRow('Carga Horaria',
                              '${asignaturaDetalle.cargaHoraria} horas'),
                          _buildInfoRow('Creado',
                              _formatDate(asignaturaDetalle.creadoEn)),
                          _buildInfoRow('Modificado',
                              _formatDate(asignaturaDetalle.modificadoEn)),
                        ],
                      ),
                      SizedBox(height: 24),
                      // Docentes
                      _buildDocentesSection(ref, token, context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff2350ba),
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocentesSection(
      WidgetRef ref, String token, BuildContext context) {
    final docentesAsync = ref.watch(docentesAsignaturaProvider((
      token: token,
      asignaturaId: asignaturaId,
    )));

    return docentesAsync.when(
      loading: () => _buildInfoSection(
        title: 'Docentes',
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      error: (error, stack) => _buildInfoSection(
        title: 'Docentes',
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  SizedBox(height: 8),
                  Text(
                    'Error al cargar docentes',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      data: (docentes) => _buildInfoSection(
        title: 'Docentes (${docentes.length})',
        children: [
          // Botón para asociar docente
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff2350ba), Color(0xff1a3f8f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff2350ba).withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showAsociarDocenteDialog(context),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Asociar Docente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Lista de docentes
          ...(docentes.isEmpty
              ? [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(Icons.people_outline,
                              size: 48, color: Colors.grey[400]),
                          SizedBox(height: 8),
                          Text(
                            'No hay docentes asignados',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              : docentes
                  .map((docente) => _buildDocenteCard(context, docente))
                  .toList()),
        ],
      ),
    );
  }

  Widget _buildDocenteCard(BuildContext context, DocenteAsignatura docente) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: isTablet
          ? _buildTabletLayout(context, docente)
          : _buildMobileLayout(context, docente),
    );
  }

  Widget _buildTabletLayout(BuildContext context, DocenteAsignatura docente) {
    return Row(
      children: [
        // Avatar del docente
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xff2350ba).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: docente.fotoDocente != null && docente.fotoDocente!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    docente.fotoDocente!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: Color(0xff2350ba),
                        size: 24,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.person,
                  color: Color(0xff2350ba),
                  size: 24,
                ),
        ),
        SizedBox(width: 16),
        // Información del docente
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${docente.nombres} ${docente.apellidos}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 4),
              Text(
                docente.correoElectronico,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        // Botones de acción
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            VerDocenteInfoButton(
              docenteId: docente.id,
              token: Preferences().userToken,
            ),
            SizedBox(width: 6),
            DesasociarDocenteButton(
              docente: docente,
              asignaturaId: asignaturaId,
              onSuccess: () {
                // El provider se refrescará automáticamente
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, DocenteAsignatura docente) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con avatar y nombre
        Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child:
                  docente.fotoDocente != null && docente.fotoDocente!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(22.5),
                          child: Image.network(
                            docente.fotoDocente!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Color(0xff2350ba),
                                size: 22,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Color(0xff2350ba),
                          size: 22,
                        ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${docente.nombres} ${docente.apellidos}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    docente.correoElectronico,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 12),

        // Botones de acción en fila
        Row(
          children: [
            Expanded(
              child: VerDocenteInfoButton(
                docenteId: docente.id,
                token: Preferences().userToken,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: DesasociarDocenteButton(
                docente: docente,
                asignaturaId: asignaturaId,
                onSuccess: () {
                  // El provider se refrescará automáticamente
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return dateString;
    }
  }
}
