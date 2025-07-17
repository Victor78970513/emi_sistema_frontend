import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import '../../domain/entities/docente_asignatura.dart';
import '../providers/carreras_provider.dart';
import '../../../../core/preferences/preferences.dart';
import 'desasociar_docente_button.dart';
import 'asociar_docente_dialog.dart';
import 'ver_docente_info_button.dart';

class AsignaturaDetalleContent extends ConsumerWidget {
  final String asignaturaId;

  const AsignaturaDetalleContent({
    super.key,
    required this.asignaturaId,
  });

  void _showAsociarDocenteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AsociarDocenteDialog(
        asignaturaId: asignaturaId,
        onSuccess: () {
          // Invalidar el provider de docentes para refrescar la lista
          final token = Preferences().userToken;
          if (token.isNotEmpty) {
            // No necesitamos invalidar manualmente, el provider se refrescará automáticamente
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(
        'DEBUG: AsignaturaDetalleContent - Construyendo para asignaturaId: $asignaturaId');

    final token = Preferences().userToken;
    print('DEBUG: AsignaturaDetalleContent - Token: $token');

    if (token.isEmpty) {
      return Center(
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
      );
    }

    final asignaturaDetalleAsync = ref.watch(asignaturaDetalleProvider((
      token: token,
      asignaturaId: asignaturaId,
    )));

    return asignaturaDetalleAsync.when(
      loading: () {
        print('DEBUG: AsignaturaDetalleContent - Estado: LOADING');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando detalles de la asignatura...'),
            ],
          ),
        );
      },
      error: (error, stack) {
        print('DEBUG: AsignaturaDetalleContent - Estado: ERROR - $error');
        return Center(
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
        );
      },
      data: (asignaturaDetalle) {
        print(
            'DEBUG: AsignaturaDetalleContent - Estado: DATA - ${asignaturaDetalle.materia}');

        // Usar los nuevos providers para obtener IDs de navegación
        final siguienteId = ref.watch(siguienteAsignaturaProvider((
          token: token,
          asignaturaId: asignaturaDetalle.id,
          carreraId: asignaturaDetalle.carrera.id,
        )));

        final anteriorId = ref.watch(anteriorAsignaturaProvider((
          token: token,
          asignaturaId: asignaturaDetalle.id,
          carreraId: asignaturaDetalle.carrera.id,
        )));

        final haySiguiente = siguienteId != null;
        final hayAnterior = anteriorId != null;

        print('DEBUG: ID actual: ${asignaturaDetalle.id}');
        print('DEBUG: Carrera ID: ${asignaturaDetalle.carrera.id}');
        print(
            'DEBUG: Hay anterior: $hayAnterior, Hay siguiente: $haySiguiente');
        print('DEBUG: Anterior ID: $anteriorId, Siguiente ID: $siguienteId');
        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0xff2350ba).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.book,
                        color: Color(0xff2350ba),
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asignaturaDetalle.materia,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2350ba),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            asignaturaDetalle.carrera.nombre,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Información de la asignatura
              _buildInfoSection(
                context: context,
                title: 'Información de la Asignatura',
                requireSixChildren: true,
                children: [
                  Text('${asignaturaDetalle.gestion}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text('${asignaturaDetalle.periodo}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text('${asignaturaDetalle.semestres}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text('${asignaturaDetalle.cargaHoraria} horas',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text(_formatDate(asignaturaDetalle.creadoEn),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                  Text(_formatDate(asignaturaDetalle.modificadoEn),
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
                ],
              ),
              SizedBox(height: 24),
              // Docentes
              _buildDocentesSection(ref, token, context),
              // Navegación entre asignaturas (eliminada, ahora en AppBar)
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    bool requireSixChildren = false,
  }) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    // Validación defensiva solo si se requiere
    if (requireSixChildren && children.length < 6) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff2350ba).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.info_outline,
                      color: Color(0xff2350ba), size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff2350ba),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'No hay información suficiente para mostrar los detalles de la asignatura.',
              style: TextStyle(fontSize: 16, color: Colors.red[700]),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xff2350ba).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.info_outline,
                    color: Color(0xff2350ba), size: 24),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2350ba),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (requireSixChildren)
            (isDesktop
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _infoRowWithIcon(
                                Icons.calendar_today, 'Gestión', children[0]),
                            Divider(height: 24),
                            _infoRowWithIcon(
                                Icons.school, 'Semestre', children[2]),
                            Divider(height: 24),
                            _infoRowWithIcon(
                                Icons.access_time, 'Creado', children[4]),
                          ],
                        ),
                      ),
                      SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          children: [
                            _infoRowWithIcon(
                                Icons.label, 'Período', children[1]),
                            Divider(height: 24),
                            _infoRowWithIcon(
                                Icons.timer, 'Carga Horaria', children[3]),
                            Divider(height: 24),
                            _infoRowWithIcon(
                                Icons.edit, 'Modificado', children[5]),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _infoRowWithIcon(
                          Icons.calendar_today, 'Gestión', children[0]),
                      Divider(height: 24),
                      _infoRowWithIcon(Icons.label, 'Período', children[1]),
                      Divider(height: 24),
                      _infoRowWithIcon(Icons.school, 'Semestre', children[2]),
                      Divider(height: 24),
                      _infoRowWithIcon(
                          Icons.timer, 'Carga Horaria', children[3]),
                      Divider(height: 24),
                      _infoRowWithIcon(
                          Icons.access_time, 'Creado', children[4]),
                      Divider(height: 24),
                      _infoRowWithIcon(Icons.edit, 'Modificado', children[5]),
                    ],
                  ))
          else
            ...children,
        ],
      ),
    );
  }

  Widget _infoRowWithIcon(IconData icon, String label, Widget valueWidget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xff2350ba), size: 20),
        SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: valueWidget),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
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
        context: context,
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
        context: context,
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
        context: context,
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
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff2350ba).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showAsociarDocenteDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.white,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Asociar Docente',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
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
                  .map((docente) =>
                      _buildDocenteCard(context, docente, ref, token))
                  .toList()),
        ],
      ),
    );
  }

  Widget _buildDocenteCard(BuildContext context, DocenteAsignatura docente,
      WidgetRef ref, String token) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: isTablet
          ? _buildTabletLayout(context, docente, ref, token)
          : _buildMobileLayout(context, docente, ref, token),
    );
  }

  Widget _buildTabletLayout(BuildContext context, DocenteAsignatura docente,
      WidgetRef ref, String token) {
    return Column(
      children: [
        Row(
          children: [
            // Avatar del docente
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child:
                  docente.fotoDocente != null && docente.fotoDocente!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            "${Constants.baseUrl}uploads/docentes/${docente.fotoDocente!}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Color(0xff2350ba),
                                size: 30,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Color(0xff2350ba),
                          size: 30,
                        ),
            ),
            SizedBox(width: 20),
            // Información del docente
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${docente.nombres} ${docente.apellidos}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    docente.correoElectronico,
                    style: TextStyle(
                      fontSize: 16,
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
                  token: token,
                ),
                SizedBox(width: 8),
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
        ),
        // Sección expandible de asignaturas del docente
        SizedBox(height: 16),
        _buildAsignaturasDocenteSection(context, docente.id, ref, token),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, DocenteAsignatura docente,
      WidgetRef ref, String token) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con avatar y nombre
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              child:
                  docente.fotoDocente != null && docente.fotoDocente!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            "${Constants.baseUrl}uploads/docentes/${docente.fotoDocente!}",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Color(0xff2350ba),
                                size: 25,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Color(0xff2350ba),
                          size: 25,
                        ),
            ),
            SizedBox(width: 16),
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
                  SizedBox(height: 2),
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
          ],
        ),

        SizedBox(height: 16),

        // Botones de acción en columna
        Row(
          children: [
            Expanded(
              child: VerDocenteInfoButton(
                docenteId: docente.id,
                token: token,
              ),
            ),
            SizedBox(width: 12),
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

        // Sección expandible de asignaturas del docente
        SizedBox(height: 16),
        _buildAsignaturasDocenteSection(context, docente.id, ref, token),
      ],
    );
  }

  Widget _buildAsignaturasDocenteSection(
      BuildContext context, String docenteId, WidgetRef ref, String token) {
    final docenteDetalleAsync = ref.watch(docenteDetalleProvider((
      token: token,
      docenteId: docenteId,
    )));

    return docenteDetalleAsync.when(
      loading: () => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Cargando asignaturas...',
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
      error: (error, stack) => Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: Colors.red[600]),
            SizedBox(width: 8),
            Text('Error al cargar asignaturas',
                style: TextStyle(fontSize: 14, color: Colors.red[600])),
          ],
        ),
      ),
      data: (docenteDetalle) {
        final asignaturas = docenteDetalle.asignaturas;
        final totalHoras = docenteDetalle.totalHorasSemanales ?? 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book, color: Color(0xff2350ba)),
                SizedBox(width: 8),
                Text(
                  'Asignaturas que también imparte el docente',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2350ba),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xff2350ba),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${asignaturas.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Horas académicas asignadas: ${totalHoras.toStringAsFixed(1)} Horas',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            Text(
              'Horas académicas restantes: ${(25 - totalHoras).toStringAsFixed(1)} Horas',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: asignaturas.isEmpty
                    ? [
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Colors.grey[500]),
                            SizedBox(width: 8),
                            Text(
                              'No hay otras asignaturas asignadas',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ]
                    : asignaturas
                        .map((asignatura) => _buildAsignaturaItem(asignatura))
                        .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAsignaturaItem(dynamic asignatura) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book, size: 16, color: Color(0xff2350ba)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  asignatura.materia ?? 'Sin nombre',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          if (asignatura.carreraNombre != null &&
              asignatura.carreraNombre.toString().isNotEmpty) ...[
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.school, size: 14, color: Color(0xff6366f1)),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    asignatura.carreraNombre,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff6366f1),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 4),
          Row(
            children: [
              _buildAsignaturaChip(
                  'Gestión ${asignatura.gestion}', Colors.blue),
              SizedBox(width: 8),
              _buildAsignaturaChip(
                  'Periodo ${asignatura.periodo}', Colors.green),
              SizedBox(width: 8),
              _buildAsignaturaChip(
                  '${asignatura.horasSemanales?.toStringAsFixed(1) ?? 0} horas académicas',
                  Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAsignaturaChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
