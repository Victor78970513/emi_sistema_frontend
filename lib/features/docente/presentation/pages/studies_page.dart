import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';



class StudiesPage extends ConsumerWidget {
  const StudiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estudiosState = ref.watch(estudiosAcademicosProvider);
    final isDesktop = MediaQuery.of(context).size.width > 1024;
    final isTablet = MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 1024;
    final crossAxisCount = isDesktop
        ? 4
        : isTablet
            ? 2
            : 1;
    final showFab = !isDesktop && !isTablet;

    return Container(
      color: const Color(0xFFF4F6FB), // Fondo general gris claro
      child: Stack(
        children: [
          Column(
            children: [
              // HEADER VISUAL CON DEGRADADO
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffE3F0FF), // azul muy suave
                      Color(0xffF4F6FB), // gris claro
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Mis Estudios Académicos',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A237E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (isDesktop || isTablet)
                      ElevatedButton.icon(
                        onPressed: () => _showCreateStudyModal(context, ref),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Crear Estudio'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4A90E2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
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
                    padding: const EdgeInsets.all(24.0),
                    child: Builder(
                      builder: (context) {
                        if (estudiosState is EstudiosAcademicosLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (estudiosState is EstudiosAcademicosErrorState) {
                          return Center(
                              child: Text('Error al cargar estudios'));
                        }
                        if (estudiosState is EstudiosAcademicosSuccessState) {
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
                        return const SizedBox.shrink();
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
                backgroundColor: const Color(0xff4A90E2),
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
            color: Colors.black.withOpacity(0.05),
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
            estudio.institucionNombre ?? 'Sin institución',
            style: const TextStyle(fontSize: 15, color: Color(0xff4A5A6A)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(estudio.gradoAcademicoNombre ?? 'Sin grado'),
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
                    estudio.anioTitulacion?.toString() ?? '-',
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
              // gg
              onPressed: () async {
                try {
                  final url = 'http://localhost:3000/uploads/estudios_academicos/${estudio.documentoUrl}';
                  
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No se pudo abrir el documento')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al acceder al documento')),
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
class _CreateStudyDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const _CreateStudyDialog({required this.onSuccess});

  @override
  State<_CreateStudyDialog> createState() => _CreateStudyDialogState();
}

class _CreateStudyDialogState extends State<_CreateStudyDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _anioController = TextEditingController();
  int? _institucionId;
  int? _gradoId;
  String? _pdfName;
  dynamic _pdfFile;
  bool _loading = false;
  List<dynamic> _instituciones = [];
  List<dynamic> _grados = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    try {
      final instituciones = await _getInstituciones();
      final grados = await _getGrados();
      setState(() {
        _instituciones = instituciones;
        _grados = grados;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos';
        _loading = false;
      });
    }
  }

  Future<List<dynamic>> _getInstituciones() async {
    // Aquí deberías usar tu cliente http/dio y el token
    // Ejemplo simple:
    final response =
        await Dio().get('http://localhost:3000/api/docente/instituciones');
    return response.data
        .map(
            (e) => {'id': int.parse(e['id'].toString()), 'nombre': e['nombre']})
        .toList();
  }

  Future<List<dynamic>> _getGrados() async {
    final response =
        await Dio().get('http://localhost:3000/api/docente/grados-academicos');
    return response.data
        .map(
            (e) => {'id': int.parse(e['id'].toString()), 'nombre': e['nombre']})
        .toList();
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: _loading
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
                        items: _instituciones
                            .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
                                  value: e['id'],
                                  child: Text(e['nombre']),
                                ))
                            .toList(),
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
                        items: _grados
                            .map<DropdownMenuItem<int>>((e) => DropdownMenuItem(
                                  value: e['id'],
                                  child: Text(e['nombre']),
                                ))
                            .toList(),
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
                          if (v == null || v.trim().isEmpty)
                            return 'Campo requerido';
                          final n = int.tryParse(v);
                          if (n == null ||
                              n < 1900 ||
                              n > DateTime.now().year + 1)
                            return 'Año inválido';
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
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(_error!,
                            style: const TextStyle(color: Colors.red)),
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
                            onPressed: _loading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4A90E2),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Guardar'),
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

  @override
  Future<void> _submit() async {
    print('--- Enviando formulario de estudio académico ---');
    print('Título: \\${_tituloController.text}');
    print('Institución: \\$_institucionId');
    print('Grado: \\$_gradoId');
    print('Año: \\${_anioController.text}');
    print('PDF: \\$_pdfName');
    if (!_formKey.currentState!.validate() ||
        _institucionId == null ||
        _gradoId == null ||
        _pdfFile == null) {
      setState(() => _error = 'Completa todos los campos y adjunta el PDF');
      print('Validación fallida');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      final formData = FormData.fromMap({
        'titulo': _tituloController.text.trim(),
        'institucion_id': _institucionId,
        'grado_academico_id': _gradoId,
        'año_titulacion': int.tryParse(_anioController.text.trim()),
        'documento': MultipartFile.fromBytes(_pdfFile, filename: _pdfName),
      });
      print('FormData listo, enviando petición...');
      final response = await dio.post(
          'http://localhost:3000/api/docente/estudios-academicos',
          data: formData);
      print('Respuesta backend: \\${response.statusCode} - \\${response.data}');
      widget.onSuccess();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('Error backend: \\${e.response?.data}');
      }
      print('Error al guardar: \\$e');
      setState(() {
        _error = 'Error al guardar. Intenta nuevamente.';
        _loading = false;
      });
    }
  }
}
