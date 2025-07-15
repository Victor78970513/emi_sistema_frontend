import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_form_provider.dart';

class StudiesPage extends ConsumerWidget {
  const StudiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estudiosState = ref.watch(estudiosAcademicosProvider);
    final docenteState = ref.watch(docenteProvider);
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isTablet = MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 1024;
    final crossAxisCount = isDesktop
        ? 3
        : isTablet
            ? 2
            : 1;
    final showFab = !isDesktop;

    // Disparar carga de estudios si el estado es inicial
    if (estudiosState is! EstudiosAcademicosLoadingState &&
        estudiosState is! EstudiosAcademicosSuccessState &&
        estudiosState is! EstudiosAcademicosErrorState) {
      if (docenteState is DocenteSuccessState && docenteState.docente != null) {
        final docenteId = docenteState.docente!.docenteId;
        Future.microtask(() {
          ref
              .read(estudiosAcademicosProvider.notifier)
              .getEstudiosAcademicos(docenteId: docenteId);
        });
      }
    }

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            children: [
              // Header elegante (mantenemos el existente)
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
                              Icons.school_rounded,
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
                                  "Mis Estudios Académicos",
                                  style: TextStyle(
                                    color: Color(0xff2350ba),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Gestiona tu información académica y profesional",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isDesktop)
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showCreateStudyModal(context, ref),
                              icon: Icon(Icons.add,
                                  color: Colors.white, size: 20),
                              label: Text(
                                'Crear Estudio',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2350ba),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
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
                                  Icons.school_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Mis Estudios Académicos",
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
                            "Gestiona tu información académica y profesional",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
              ),
              // CONTENIDO PRINCIPAL MEJORADO
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: 16,
                    ),
                    child: Builder(
                      builder: (context) {
                        if (estudiosState is EstudiosAcademicosLoadingState) {
                          return _buildLoadingState();
                        }
                        if (estudiosState is EstudiosAcademicosErrorState) {
                          return _buildErrorState();
                        }
                        if (estudiosState is EstudiosAcademicosSuccessState) {
                          final estudios = estudiosState.estudios;
                          if (estudios.isEmpty) {
                            return _buildEmptyState();
                          }
                          return _buildStudiesGrid(
                              estudios, crossAxisCount, isDesktop);
                        }
                        return _buildInitialState();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showFab)
            Positioned(
              bottom: 32,
              right: 32,
              child: FloatingActionButton.extended(
                onPressed: () => _showCreateStudyModal(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Estudio'),
                backgroundColor: const Color(0xff2350ba),
                foregroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xff2350ba).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2350ba)),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Cargando estudios académicos...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Error al cargar estudios',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta nuevamente más tarde',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Color(0xff2350ba).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.school_outlined,
              size: 64,
              color: Color(0xff2350ba),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Aún no tienes estudios registrados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Comienza agregando tu primer estudio académico',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2350ba)),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando estudios académicos...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudiesGrid(List<EstudioAcademicoModel> estudios,
      int crossAxisCount, bool isDesktop) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        // childAspectRatio: isDesktop ? 1.5 : 1.6,
        childAspectRatio: 1.5,
      ),
      itemCount: estudios.length,
      itemBuilder: (context, index) {
        final estudio = estudios[index];
        return _ModernStudyCard(estudio: estudio);
      },
    );
  }

  void _showCreateStudyModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateStudyDialog(onSuccess: () {
        // Refrescar lista al guardar
        final docenteState = ref.read(docenteProvider);
        if (docenteState is DocenteSuccessState &&
            docenteState.docente != null) {
          final docenteId = docenteState.docente!.docenteId;
          ref
              .read(estudiosAcademicosProvider.notifier)
              .getEstudiosAcademicos(docenteId: docenteId);
        }
      }),
    );
  }
}

class _ModernStudyCard extends StatelessWidget {
  final EstudioAcademicoModel estudio;
  const _ModernStudyCard({required this.estudio});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xfff8fafc),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xffe2e8f0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showStudyDetails(context),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con icono y badge
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff2350ba),
                            Color(0xff1e40af),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff10b981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xff10b981),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Completado',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xff10b981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Título del estudio
                Text(
                  estudio.titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),

                // Institución
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        estudio.institucionNombre,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                // Grado académico
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2350ba).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    estudio.gradoAcademicoNombre,
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff2350ba),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),

                // Footer con año y botón
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: 3),
                    Text(
                      estudio.anioTitulacion.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xff2350ba),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Ver mas",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStudyDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudyDetailsSheet(estudio: estudio),
    );
  }
}

class _StudyDetailsSheet extends StatelessWidget {
  final EstudioAcademicoModel estudio;

  const _StudyDetailsSheet({required this.estudio});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff2350ba),
                            Color(0xff1e40af),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalles del Estudio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'Información completa',
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
                SizedBox(height: 24),

                // Información del estudio
                _DetailRow(
                  icon: Icons.school,
                  label: 'Título',
                  value: estudio.titulo,
                ),
                SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.business,
                  label: 'Institución',
                  value: estudio.institucionNombre,
                ),
                SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.workspace_premium,
                  label: 'Grado Académico',
                  value: estudio.gradoAcademicoNombre,
                ),
                SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Año de Titulación',
                  value: estudio.anioTitulacion.toString(),
                ),
                SizedBox(height: 24),

                // Botón para ver PDF
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
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
                              SnackBar(
                                  content:
                                      Text('No se pudo abrir el documento')),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al acceder al documento')),
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.download, size: 20, color: Colors.white),
                    label: Text('Ver Documento PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2350ba),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xff2350ba).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Color(0xff2350ba),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- Dialogo de creación ---
class _CreateStudyDialog extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  const _CreateStudyDialog({required this.onSuccess});

  @override
  ConsumerState<_CreateStudyDialog> createState() => _CreateStudyDialogState();
}

class _CreateStudyDialogState extends ConsumerState<_CreateStudyDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  int? _institucionId;
  int? _gradoId;
  String? _pdfName;
  dynamic _pdfFile;
  bool _intentoGuardar = false;

  @override
  void initState() {
    super.initState();
    // Ya no es necesario cargar datos aquí, se precargan en DocenteHomePage
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(estudiosAcademicosFormProvider.notifier).fetchAllData();
    // });
  }

  Future<void> _pickPDF() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _pdfFile = result.files.single.bytes;
        _pdfName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(estudiosAcademicosFormProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: BoxConstraints(
            maxWidth: 500, maxHeight: MediaQuery.of(context).size.height * 0.8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: formState.instituciones.isLoading || formState.grados.isLoading
            ? Container(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: CircularProgressIndicator(
                          color: Color(0xff2350ba),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando opciones...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2350ba),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header con gradiente
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff2350ba),
                            Color(0xff1e40af),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuevo Estudio Académico',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Agrega tu información académica',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                              shape: CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Contenido del formulario
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Campo Título
                            _buildModernFormField(
                              controller: _tituloController,
                              label: 'Título del Estudio',
                              hint: 'Ej: Ingeniería en Sistemas',
                              icon: Icons.school,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Campo obligatorio'
                                  : null,
                            ),
                            SizedBox(height: 20),

                            // Campo Institución
                            _buildModernDropdownField(
                              value: _institucionId,
                              label: 'Institución',
                              hint: 'Selecciona una institución',
                              icon: Icons.business,
                              items: formState.instituciones.when(
                                data: (instituciones) => instituciones
                                    .map<DropdownMenuItem<int>>(
                                        (institucion) => DropdownMenuItem(
                                              value: institucion.id,
                                              child: Text(
                                                institucion.nombre,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                    .toList(),
                                loading: () => [],
                                error: (_, __) => [],
                              ),
                              onChanged: (v) =>
                                  setState(() => _institucionId = v),
                              validator: (v) =>
                                  v == null ? 'Campo obligatorio' : null,
                            ),
                            SizedBox(height: 20),

                            // Campo Grado Académico
                            _buildModernDropdownField(
                              value: _gradoId,
                              label: 'Grado Académico',
                              hint: 'Selecciona un grado',
                              icon: Icons.verified,
                              items: formState.grados.when(
                                data: (grados) => grados
                                    .map<DropdownMenuItem<int>>(
                                        (grado) => DropdownMenuItem(
                                              value: grado.id,
                                              child: Text(grado.nombre),
                                            ))
                                    .toList(),
                                loading: () => [],
                                error: (_, __) => [],
                              ),
                              onChanged: (v) => setState(() => _gradoId = v),
                              validator: (v) =>
                                  v == null ? 'Campo obligatorio' : null,
                            ),
                            SizedBox(height: 20),

                            // Campo Año
                            _buildModernFormField(
                              controller: _anioController,
                              label: 'Año de Titulación',
                              hint: 'Ej: 2023',
                              icon: Icons.calendar_today,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Campo obligatorio';
                                }
                                final n = int.tryParse(v);
                                if (n == null ||
                                    n < 1900 ||
                                    n > DateTime.now().year + 1) {
                                  return 'Año inválido';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20),

                            // Campo PDF
                            _buildModernFileField(),
                            SizedBox(height: 20),

                            // Mensaje de error
                            if (formState.submitState
                                is EstudiosAcademicosFormError) ...[
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error_outline,
                                        color: Colors.red, size: 16),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        (formState.submitState
                                                as EstudiosAcademicosFormError)
                                            .message,
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // Botones de acción
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Color(0xff2350ba)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Color(0xff2350ba),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: formState.submitState
                                      is EstudiosAcademicosFormLoading
                                  ? null
                                  : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2350ba),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: formState.submitState
                                      is EstudiosAcademicosFormLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Guardando...'),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.save,
                                            size: 20, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'Guardar Estudio',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildModernFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xff2350ba),
              ),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xff2350ba), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          validator: (v) {
            if (validator != null) {
              final result = validator(v);
              if (result != null) return result;
            }
            if (v == null || v.trim().isEmpty) {
              return 'Campo obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildModernDropdownField({
    required int? value,
    required String label,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<int>> items,
    required Function(int?) onChanged,
    required String? Function(int?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xff2350ba),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: DropdownButtonFormField<int>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            items: items,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            dropdownColor: Colors.white,
            validator: (v) {
              if (validator != null) {
                final result = validator(v);
                if (result != null) return result;
              }
              if (v == null) {
                return 'Campo obligatorio';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernFileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.attach_file,
                size: 16,
                color: Color(0xff2350ba),
              ),
            ),
            SizedBox(width: 12),
            Text(
              'Documento PDF',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _pdfName != null ? Colors.green : Colors.grey[300]!,
              width: _pdfName != null ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: _pdfName != null
                ? Colors.green.withValues(alpha: 0.05)
                : Colors.grey[50],
          ),
          child: InkWell(
            onTap: _pickPDF,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    _pdfName != null ? Icons.check_circle : Icons.upload_file,
                    color: _pdfName != null ? Colors.green : Color(0xff2350ba),
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _pdfName ?? 'Seleccionar archivo PDF',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _pdfName != null
                                ? Colors.green
                                : Colors.black87,
                          ),
                        ),
                        if (_pdfName != null) ...[
                          SizedBox(height: 4),
                          Text(
                            'Archivo seleccionado correctamente',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 4),
                          Text(
                            'Haz clic para seleccionar un archivo PDF',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_intentoGuardar && _pdfFile == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text(
              'Seleccionar un archivo PDF es obligatorio',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Validar todos los campos obligatorios
    setState(() {
      _intentoGuardar = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (!isValid ||
        _institucionId == null ||
        _gradoId == null ||
        _pdfFile == null) {
      // El mensaje de PDF obligatorio se mostrará si falta
      return;
    }

    print('--- Enviando formulario de estudio académico ---');
    print('Título: ${_tituloController.text}');
    print('Institución: $_institucionId');
    print('Grado: $_gradoId');
    print('Año: ${_anioController.text}');
    print('PDF: $_pdfName');

    try {
      await ref
          .read(estudiosAcademicosFormProvider.notifier)
          .submitEstudioAcademico(
            titulo: _tituloController.text.trim(),
            institucionId: _institucionId!,
            gradoId: _gradoId!,
            anioTitulacion: int.tryParse(_anioController.text.trim())!,
            pdfBytes: _pdfFile,
            pdfName: _pdfName!,
          );

      final currentState = ref.read(estudiosAcademicosFormProvider).submitState;
      if (currentState is EstudiosAcademicosFormSuccess) {
        widget.onSuccess();
        if (mounted) Navigator.of(context).pop();
        // Resetear el estado del submit
        ref.read(estudiosAcademicosFormProvider.notifier).resetSubmitState();
      }
    } catch (e) {
      print('Error al guardar: $e');
    }
  }
}
