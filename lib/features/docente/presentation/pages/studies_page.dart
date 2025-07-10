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
        ? 4
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
                              // El botón se elimina en móviles/tablets para usar solo el FAB
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
              // CONTENIDO PRINCIPAL
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
                          print('StudiesPage: Estado loading');
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (estudiosState is EstudiosAcademicosErrorState) {
                          print('StudiesPage: Estado error');
                          return Center(
                              child: Text('Error al cargar estudios'));
                        }
                        if (estudiosState is EstudiosAcademicosSuccessState) {
                          print(
                              'StudiesPage: Estado success, estudios: ${estudiosState.estudios.length}');
                          final estudios = estudiosState.estudios;
                          if (estudios.isEmpty) {
                            return _buildEmptyState();
                          }
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: estudios.length,
                            itemBuilder: (context, index) {
                              final estudio = estudios[index];
                              return _StudyCard(estudio: estudio);
                            },
                          );
                        }
                        // Estado inicial o desconocido
                        print('StudiesPage: Estado inicial o desconocido');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Cargando estudios académicos...'),
                            ],
                          ),
                        );
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
                elevation: 4,
              ),
            ),
        ],
      ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'Aún no tienes estudios académicos registrados.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StudyCard extends StatelessWidget {
  final EstudioAcademicoModel estudio;
  const _StudyCard({required this.estudio});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffF7FAFC), // gris azulado muy claro
            Color(0xffE3F0FF), // azul muy suave
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffB3D1F7), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xffE3F2FD),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.picture_as_pdf,
                color: Color(0xffE53935), size: 48),
          ),
          const SizedBox(height: 18),
          Text(
            estudio.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff1A237E),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            estudio.institucionNombre,
            style: const TextStyle(fontSize: 15, color: Color(0xff4A5A6A)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(estudio.gradoAcademicoNombre),
                backgroundColor: const Color(0xffE3F2FD),
                labelStyle: const TextStyle(color: Color(0xff1976D2)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Color(0xff4A90E2)),
                  const SizedBox(width: 4),
                  Text(
                    estudio.anioTitulacion.toString(),
                    style:
                        const TextStyle(fontSize: 15, color: Color(0xff1A237E)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                        const SnackBar(
                            content: Text('No se pudo abrir el documento')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Error al acceder al documento')),
                    );
                  }
                }
              },
              icon: const Icon(
                Icons.download,
                size: 20,
                color: Colors.white,
              ),
              label: const Text('Ver PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4A90E2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
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

  @override
  void initState() {
    super.initState();
    // Cargar datos al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(estudiosAcademicosFormProvider.notifier).fetchAllData();
    });
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: formState.instituciones.isLoading || formState.grados.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Nuevo Estudio Académico',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4A90E2),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Campo requerido'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _institucionId,
                        items: formState.instituciones.when(
                          data: (instituciones) => instituciones
                              .map<DropdownMenuItem<int>>(
                                  (institucion) => DropdownMenuItem(
                                        value: institucion.id,
                                        child: Text(institucion.nombre),
                                      ))
                              .toList(),
                          loading: () => [],
                          error: (_, __) => [],
                        ),
                        onChanged: (v) => setState(() => _institucionId = v),
                        decoration: const InputDecoration(
                          labelText: 'Institución',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null ? 'Selecciona una institución' : null,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _gradoId,
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
                        decoration: const InputDecoration(
                          labelText: 'Grado Académico',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null ? 'Selecciona un grado académico' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _anioController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Año de Titulación',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Campo requerido';
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickPDF,
                              icon: const Icon(Icons.attach_file),
                              label: Text(_pdfName ?? 'Adjuntar PDF'),
                            ),
                          ),
                          if (_pdfName != null)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child:
                                  Icon(Icons.check_circle, color: Colors.green),
                            ),
                        ],
                      ),
                      if (formState.submitState
                          is EstudiosAcademicosFormError) ...[
                        const SizedBox(height: 12),
                        Text(
                          (formState.submitState as EstudiosAcademicosFormError)
                              .message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: formState.submitState
                                    is EstudiosAcademicosFormLoading
                                ? null
                                : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4A90E2),
                              foregroundColor: Colors.white,
                            ),
                            child: formState.submitState
                                    is EstudiosAcademicosFormLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text('Guardar'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    print('--- Enviando formulario de estudio académico ---');
    print('Título: ${_tituloController.text}');
    print('Institución: $_institucionId');
    print('Grado: $_gradoId');
    print('Año: ${_anioController.text}');
    print('PDF: $_pdfName');

    if (!_formKey.currentState!.validate() ||
        _institucionId == null ||
        _gradoId == null ||
        _pdfFile == null) {
      return;
    }

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
