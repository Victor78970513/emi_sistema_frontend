import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/docente_detalle_response_model.dart';
import '../providers/carreras_provider.dart';
import '../../../docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/constants.dart';

class DocenteInfoBottomSheet extends ConsumerStatefulWidget {
  final String docenteId;
  final String token;

  const DocenteInfoBottomSheet({
    super.key,
    required this.docenteId,
    required this.token,
  });

  @override
  ConsumerState<DocenteInfoBottomSheet> createState() =>
      _DocenteInfoBottomSheetState();
}

class _DocenteInfoBottomSheetState
    extends ConsumerState<DocenteInfoBottomSheet> {
  String? _lastDocenteId;

  void _loadEstudios(String docenteId) {
    _lastDocenteId = docenteId;
    final docenteIdInt = int.tryParse(docenteId);
    if (docenteIdInt != null) {
      ref
          .read(estudiosAcademicosProvider.notifier)
          .getEstudiosAcademicos(docenteId: docenteIdInt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docenteDetalleAsync = ref.watch(
      docenteDetalleProvider(
          (token: widget.token, docenteId: widget.docenteId)),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: docenteDetalleAsync.when(
        data: (docente) {
          final docenteIdStr = docente.data.docenteId;
          if (_lastDocenteId != docenteIdStr) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _loadEstudios(docenteIdStr);
            });
          }
          return _buildContent(context, docente, ref);
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar información',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context,
      DocenteDetalleResponseModel docenteResponse, WidgetRef ref) {
    final docente = docenteResponse.data;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // Header eliminado para evitar duplicidad visual

          // Barra de arrastre
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Contenido principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar y nombre
                  Row(
                    children: [
                      CircleAvatar(
                        radius: isTablet ? 35 : 30,
                        backgroundColor:
                            const Color(0xff2350ba).withOpacity(0.1),
                        backgroundImage: (docente.fotoDocente != null &&
                                docente.fotoDocente!.isNotEmpty)
                            ? NetworkImage(
                                "${Constants.baseUrl}uploads/docentes/${docente.fotoDocente!}")
                            : null,
                        child: (docente.fotoDocente != null &&
                                docente.fotoDocente!.isNotEmpty)
                            ? null
                            : Text(
                                (docente.nombres.isNotEmpty
                                    ? docente.nombres[0].toUpperCase()
                                    : ''),
                                style: TextStyle(
                                  fontSize: isTablet ? 28 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2350ba),
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${docente.nombres} ${docente.apellidos}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: isTablet ? 18 : 16,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID: ${docente.docenteId}',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Contenido con tabs
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // Tabs
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey[600],
                              indicator: BoxDecoration(
                                color: const Color(0xff2350ba),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person,
                                          size: isTablet ? 16 : 14),
                                      SizedBox(width: isTablet ? 8 : 6),
                                      Text('Información Personal',
                                          style: TextStyle(
                                              fontSize: isTablet ? 14 : 12)),
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.school,
                                          size: isTablet ? 16 : 14),
                                      SizedBox(width: isTablet ? 8 : 6),
                                      Text('Estudios Académicos',
                                          style: TextStyle(
                                              fontSize: isTablet ? 14 : 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Contenido de los tabs
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Tab 1: Información Personal
                                _buildInformacionPersonal(
                                    context, docente, isTablet),

                                // Tab 2: Estudios Académicos
                                _buildEstudiosAcademicos(
                                    context, ref, isTablet),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacionPersonal(
      BuildContext context, DocenteDetalleDataModel docente, bool isTablet) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
                color: Color(0xff2350ba).withValues(alpha: 0.08), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xff2350ba).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.person, color: Color(0xff2350ba), size: 28),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Información del Docente',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2350ba),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildInfoRow('Nombres', docente.nombres, Icons.person, isTablet),
              _buildInfoRow(
                  'Apellidos', docente.apellidos, Icons.person, isTablet),
              _buildInfoRow('Carnet de Identidad', docente.carnetIdentidad,
                  Icons.credit_card, isTablet),
              _buildInfoRow('Género', docente.genero, Icons.wc, isTablet),
              _buildInfoRow(
                  'Fecha de Nacimiento',
                  docente.fechaNacimiento?.toString().split(' ')[0],
                  Icons.calendar_today,
                  isTablet),
              _buildInfoRow('Correo Electrónico', docente.correoElectronico,
                  Icons.email, isTablet),
              _buildInfoRow(
                  'Experiencia Profesional',
                  docente.experienciaProfesional?.isNotEmpty == true
                      ? docente.experienciaProfesional!
                      : null,
                  Icons.work,
                  isTablet),
              _buildInfoRow(
                  'Experiencia Académica',
                  docente.experienciaAcademica?.isNotEmpty == true
                      ? docente.experienciaAcademica!
                      : null,
                  Icons.school,
                  isTablet),
              _buildInfoRow('Categoría Docente', docente.categoriaNombre,
                  Icons.category, isTablet),
              _buildInfoRow('Modalidad de Ingreso',
                  docente.modalidadIngresoNombre, Icons.input, isTablet),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEstudiosAcademicos(
      BuildContext context, WidgetRef ref, bool isTablet) {
    final estudiosState = ref.watch(estudiosAcademicosProvider);

    if (estudiosState is EstudiosAcademicosLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (estudiosState is EstudiosAcademicosErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar estudios académicos',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
      );
    }

    if (estudiosState is EstudiosAcademicosSuccessState) {
      final estudios = estudiosState.estudios;

      if (estudios.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay estudios académicos registrados',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: estudios.length,
        itemBuilder: (context, index) {
          final estudio = estudios[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xff2350ba).withValues(alpha: 0.10),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xff2350ba).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.school,
                          color: const Color(0xff2350ba),
                          size: isTablet ? 28 : 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              estudio.titulo,
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff2350ba),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.workspace_premium,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    estudio.gradoAcademicoNombre,
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : 13,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.business,
                                    size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    estudio.institucionNombre,
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : 13,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        'Año de titulación: ',
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        estudio.anioTitulacion.toString(),
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (estudio.documentoUrl.isNotEmpty)
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              final url =
                                  "${Constants.baseUrl}uploads/estudios_academicos/${estudio.documentoUrl}";
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url),
                                    mode: LaunchMode.externalApplication);
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'No se pudo abrir el documento')),
                                  );
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Error al acceder al documento')),
                                );
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text('Ver PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2350ba),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: TextStyle(
                                fontSize: isTablet ? 13 : 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff2350ba).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xff2350ba),
                  size: isTablet ? 18 : 16,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff2350ba),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label, String? value, IconData icon, bool isTablet) {
    final displayValue =
        (value == null || value.isEmpty) ? 'No especificado' : value;
    final isNoEspecificado = displayValue == 'No especificado';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNoEspecificado ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isNoEspecificado
              ? Colors.grey[200]!
              : const Color(0xff2350ba).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: isTablet ? 16 : 14,
            color:
                isNoEspecificado ? Colors.grey[400] : const Color(0xff2350ba),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isNoEspecificado ? Colors.grey[500] : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstudioInfo(
      String label, String value, IconData icon, bool isTablet) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: isTablet ? 14 : 12,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 11 : 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isTablet ? 13 : 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
