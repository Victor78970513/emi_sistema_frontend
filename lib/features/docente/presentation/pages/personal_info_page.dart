import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class PersonalInfoPage extends ConsumerStatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  ConsumerState<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends ConsumerState<PersonalInfoPage> {
  // Controladores para los campos de edición
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _carnetController;
  late TextEditingController _experienciaProfesionalController;
  late TextEditingController _experienciaAcademicaController;

  String _selectedGenero = 'Masculino';
  DateTime? _selectedDate;

  final List<String> _generos = ['Masculino', 'Femenino', 'Otro'];

  // Variable para verificar si el widget está montado
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _carnetController = TextEditingController();
    _experienciaProfesionalController = TextEditingController();
    _experienciaAcademicaController = TextEditingController();
  }

  @override
  void dispose() {
    _mounted = false;
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _carnetController.dispose();
    _experienciaProfesionalController.dispose();
    _experienciaAcademicaController.dispose();
    super.dispose();
  }

  // Método para mostrar SnackBar de forma segura
  void _showSnackBar(SnackBar snackBar) {
    if (_mounted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Método para seleccionar y subir foto
  Future<void> _selectAndUploadPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        dynamic imageFile;

        if (kIsWeb) {
          // Para web, usar Uint8List
          final bytes = await image.readAsBytes();
          imageFile = bytes;
        } else {
          // Para móvil, usar File
          imageFile = File(image.path);
        }

        // Mostrar mensaje de carga
        if (_mounted && context.mounted) {
          _showSnackBar(
            SnackBar(
              content: Text('Subiendo foto...'),
              backgroundColor: Color(0xff4A90E2),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Subir la foto
        await ref.read(docenteProvider.notifier).uploadDocentePhoto(imageFile);

        // Mostrar mensaje de éxito
        if (_mounted && context.mounted) {
          _showSnackBar(
            SnackBar(
              content: Text('Foto actualizada exitosamente'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('Error al seleccionar/subir foto: $e');

      // Mostrar mensaje de error
      if (_mounted && context.mounted) {
        _showSnackBar(
          SnackBar(
            content: Text('Error al subir la foto'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final docenteState = ref.watch(docenteProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        if (docenteState is DocenteLoadingState) {
          return _buildLoadingState();
        }

        if (docenteState is DocenteErrorState) {
          return _buildErrorState();
        }

        if (docenteState is DocenteSuccessState &&
            docenteState.docente != null) {
          final docente = docenteState.docente!;

          if (isDesktop) {
            return _buildDesktopLayout(context, docente, constraints);
          } else {
            return _buildMobileLayout(context, docente);
          }
        }

        return _buildEmptyState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
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
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Color(0xff4A90E2),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando información...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff4A90E2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Error al cargar la información',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'No se pudo obtener la información personal.\nVerifique su conexión e intente nuevamente.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  // Recargar la información personal
                  ref.read(docenteProvider.notifier).reloadPersonalInfo();
                },
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff4A90E2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Container(
          padding: EdgeInsets.all(32),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.person_off,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'No hay información disponible',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, docente, constraints) {
    return Container(
      color: Colors.grey[50],
      child: Row(
        children: [
          // Panel lateral con información del docente
          Container(
            width: constraints.maxWidth * 0.3,
            padding: EdgeInsets.all(32),
            child: Container(
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
              child: Column(
                children: [
                  // Avatar centrado
                  Center(
                    child: DocenteImage(
                      docente: docente,
                      backgroundColor: Color(0xff2350ba).withValues(alpha: 0.1),
                      textColor: Color(0xff2350ba),
                    ),
                  ),
                  SizedBox(height: 24),
                  // Nombre centrado
                  Text(
                    docente.names,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xff2350ba),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    docente.surnames,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  // Botones de acción
                  _buildDesktopActionButton(
                    'Editar Perfil',
                    Icons.edit,
                    () => _showEditProfileModal(context, docente),
                  ),
                  SizedBox(height: 12),
                  _buildDesktopSecondaryButton(
                    'Cambiar Foto',
                    Icons.camera_alt,
                    () => _selectAndUploadPhoto(),
                  ),
                ],
              ),
            ),
          ),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Información Personal', Icons.person),
                  SizedBox(height: 24),
                  _buildPersonalInfoGrid(docente),
                  SizedBox(height: 40),
                  _buildSectionHeader('Experiencia Profesional', Icons.work),
                  SizedBox(height: 24),
                  _buildExperienceSection(docente),
                  SizedBox(height: 40),
                  _buildSectionHeader('Información Académica', Icons.school),
                  SizedBox(height: 24),
                  _buildAcademicInfoSection(docente),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, docente) {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header simple y limpio
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar centrado
                  Center(
                    child: DocenteImage(
                      docente: docente,
                      backgroundColor: Color(0xff2350ba).withValues(alpha: 0.1),
                      textColor: Color(0xff2350ba),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Nombre centrado
                  Text(
                    docente.names,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xff2350ba),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    docente.surnames,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showEditProfileModal(context, docente),
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text('Editar Perfil'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2350ba),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _selectAndUploadPhoto(),
                          icon:
                              Icon(Icons.camera_alt, color: Color(0xff2350ba)),
                          label: Text('Cambiar Foto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            foregroundColor: Color(0xff2350ba),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Contenido principal
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSectionHeader('Información Personal', Icons.person),
                  SizedBox(height: 16),
                  _buildPersonalInfoGrid(docente),
                  SizedBox(height: 24),
                  _buildSectionHeader('Experiencia Profesional', Icons.work),
                  SizedBox(height: 16),
                  _buildExperienceSection(docente),
                  SizedBox(height: 24),
                  _buildSectionHeader('Información Académica', Icons.school),
                  SizedBox(height: 16),
                  _buildAcademicInfoSection(docente),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, docente, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar del docente
          DocenteImage(docente: docente),
          SizedBox(height: 24),
          Text(
            docente.names,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 24 : 20,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            docente.surnames,
            style: TextStyle(
              fontSize: isDesktop ? 18 : 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'ID: ${docente.docenteId}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: isDesktop ? 14 : 12,
              ),
            ),
          ),
          SizedBox(height: 32),

          // Botones de acción
          _buildActionButton(
            'Editar Perfil',
            Icons.edit,
            () {
              _showEditProfileModal(context, docente);
            },
            isDesktop,
          ),
          SizedBox(height: 12),
          _buildActionButton(
            'Cambiar Foto',
            Icons.camera_alt,
            () {
              _selectAndUploadPhoto();
            },
            isDesktop,
          ),
          // SizedBox(height: 12),
          // _buildActionButton(
          //   'Ver Estudios',
          //   Icons.school,
          //   () {
          //     context.go(AppRoutes.studiesPage);
          //   },
          //   isDesktop,
          // ),
          // SizedBox(height: 12),
          // _buildActionButton(
          //   'Descargar CV',
          //   Icons.download,
          //   () {TODO: Implementar descarga de CV
          //     print('Descargar CV');
          //   },
          //   isDesktop,
          // ),

          Spacer(),

          // Información de estado
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Información del Perfil',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildProfileStat('Campos completados', '5/8', Colors.green),
                _buildProfileStat('Última actualización', 'Hoy', Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String text, IconData icon, VoidCallback onPressed, bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isDesktop ? 18 : 16, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff2350ba),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context, docente) {
    // Inicializar controladores con los datos actuales
    _initializeControllers(docente);

    final isDesktop = MediaQuery.of(context).size.width > 1024;

    if (isDesktop) {
      // Usar Dialog para desktop
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  constraints: BoxConstraints(maxWidth: 500),
                  child: _buildEditProfileContent(
                      context, setModalState, dialogContext),
                ),
              );
            },
          );
        },
      );
    } else {
      // Usar BottomSheet para móvil/tablet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: _buildEditProfileContent(context, setModalState, null),
              );
            },
          );
        },
      );
    }
  }

  Widget _buildEditProfileContent(BuildContext context,
      StateSetter setModalState, BuildContext? dialogContext) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header del modal
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
              topLeft: Radius.circular(dialogContext != null ? 20 : 24),
              topRight: Radius.circular(dialogContext != null ? 20 : 24),
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
                  Icons.edit,
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
                      'Editar Perfil',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Actualiza tu información personal',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (dialogContext != null)
                IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: Icon(Icons.close, color: Colors.white),
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
                _buildModernEditField('Nombres', _nombresController,
                    Icons.person, 'Ingresa tus nombres'),
                SizedBox(height: 20),
                _buildModernEditField('Apellidos', _apellidosController,
                    Icons.person, 'Ingresa tus apellidos'),
                SizedBox(height: 20),
                _buildModernEditField(
                    'Email', _emailController, Icons.email, 'Ingresa tu email'),
                SizedBox(height: 20),
                _buildModernEditField('Carnet de Identidad', _carnetController,
                    Icons.badge, 'Ingresa tu carnet', TextInputType.number),
                SizedBox(height: 20),
                _buildModernDropdownField(
                    'Género', _selectedGenero, _generos, Icons.person_outline,
                    (String? newValue) {
                  setModalState(() {
                    _updateGenero(newValue);
                  });
                }),
                SizedBox(height: 20),
                _buildModernDateField(
                    'Fecha de Nacimiento', _selectedDate, Icons.calendar_today,
                    () async {
                  await _selectDate(context);
                  setModalState(() {});
                }),
                SizedBox(height: 20),
                _buildModernEditField(
                  'Experiencia Profesional',
                  _experienciaProfesionalController,
                  Icons.work,
                  'Años de experiencia',
                  TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildModernEditField(
                  'Experiencia Académica',
                  _experienciaAcademicaController,
                  Icons.school,
                  'Semestres de docencia',
                  TextInputType.number,
                ),
                SizedBox(height: 24),
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
              bottomLeft: Radius.circular(dialogContext != null ? 20 : 24),
              bottomRight: Radius.circular(dialogContext != null ? 20 : 24),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              if (isMobile) {
                // Layout en columna para móvil/tablet
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            _updateProfileAndClose(dialogContext ?? context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2350ba),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          if (dialogContext != null) {
                            Navigator.of(dialogContext).pop();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
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
                  ],
                );
              } else {
                // Layout en fila para desktop
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (dialogContext != null) {
                            Navigator.of(dialogContext).pop();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
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
                        onPressed: () =>
                            _updateProfileAndClose(dialogContext ?? context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2350ba),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Guardar Cambios',
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
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernEditField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xff4A90E2),
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
              borderSide: BorderSide(color: Color(0xff4A90E2), width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildModernDropdownField(String label, String value,
      List<String> items, IconData icon, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xff4A90E2),
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: DropdownButtonFormField<String>(
            value: value.isNotEmpty ? value : null,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            dropdownColor: Colors.white,
            hint: Text(
              'Seleccionar género',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernDateField(
      String label, DateTime? selectedDate, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Color(0xff4A90E2),
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
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Color(0xff4A90E2),
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  selectedDate != null
                      ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedDate != null
                        ? Colors.black87
                        : Colors.grey[400],
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStat(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xff4A90E2).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color(0xff4A90E2),
            size: 24,
          ),
        ),
        SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoGrid(docente) {
    return Container(
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
      child: Column(
        children: [
          _buildInfoRow('Email', docente.correoElectronico ?? 'No especificado',
              Icons.email, Colors.blue),
          _buildInfoRow(
              'Carnet de Identidad',
              docente.carnetIdentidad?.isNotEmpty == true
                  ? docente.carnetIdentidad!
                  : 'No especificado',
              Icons.badge,
              Colors.green),
          _buildInfoRow(
              'Género',
              docente.genero?.isNotEmpty == true
                  ? docente.genero!
                  : 'No especificado',
              Icons.person,
              Colors.purple),
          _buildInfoRow(
              'Fecha de Nacimiento',
              docente.fechaNacimiento != null
                  ? docente.fechaNacimiento.toString().split('T')[0]
                  : 'No especificado',
              Icons.calendar_today,
              Colors.orange),
          _buildInfoRow(
              'Foto del Docente',
              docente.fotoDocente?.isNotEmpty == true
                  ? 'Imagen cargada'
                  : 'No hay imagen',
              Icons.photo,
              Colors.teal),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceSection(docente) {
    return Container(
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
      child: Column(
        children: [
          _buildExperienceCard(
            'Experiencia Profesional',
            docente.experienciaProfesional?.isNotEmpty == true
                ? '${docente.experienciaProfesional} años'
                : 'No especificado',
            Icons.work,
            Colors.blue,
          ),
          SizedBox(height: 16),
          _buildExperienceCard(
            'Experiencia Académica',
            docente.experienciaAcademica?.isNotEmpty == true
                ? '${docente.experienciaAcademica} semestres'
                : 'No especificado',
            Icons.school,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoSection(docente) {
    return Container(
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
      child: Column(
        children: [
          _buildInfoRow(
              'Categoría Docente',
              docente.categoriaNombre?.isNotEmpty == true
                  ? docente.categoriaNombre!
                  : 'No especificado',
              Icons.category,
              Colors.purple),
          _buildInfoRow(
              'Modalidad de Ingreso',
              docente.modalidadIngresoNombre?.isNotEmpty == true
                  ? docente.modalidadIngresoNombre!
                  : 'No especificado',
              Icons.login,
              Colors.orange),
        ],
      ),
    );
  }

  // Métodos para manejar la fecha y género
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xff2350ba),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateGenero(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedGenero = newValue;
      });
    }
  }

  // Método para actualizar el perfil y cerrar el modal
  Future<void> _updateProfileAndClose(BuildContext context) async {
    try {
      final Map<String, dynamic> profileData = {
        'nombres': _nombresController.text,
        'apellidos': _apellidosController.text,
        'correo_electronico': _emailController.text,
        'carnet_identidad': _carnetController.text,
        'genero': _selectedGenero,
        'experiencia_profesional':
            int.tryParse(_experienciaProfesionalController.text) ?? 0,
        'experiencia_academica':
            int.tryParse(_experienciaAcademicaController.text) ?? 0,
      };

      // Agregar fecha de nacimiento si está seleccionada
      if (_selectedDate != null) {
        profileData['fecha_nacimiento'] = _selectedDate!.toIso8601String();
      }

      print('PersonalInfoPage - Datos a enviar: $profileData');

      // Cerrar el modal primero
      Navigator.of(context).pop();

      // Actualizar el perfil después de cerrar el modal
      await ref
          .read(docenteProvider.notifier)
          .updateDocenteProfile(profileData);

      // Mostrar mensaje de éxito
      if (_mounted && context.mounted) {
        _showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Perfil actualizado correctamente'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      print('PersonalInfoPage - Error en actualización: $e');

      // Mostrar mensaje de error
      if (_mounted && context.mounted) {
        _showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('Error al actualizar el perfil: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  // Método para inicializar los controladores con los datos del docente
  void _initializeControllers(docente) {
    // Limpiar controladores antes de asignar nuevos valores
    _nombresController.clear();
    _apellidosController.clear();
    _emailController.clear();
    _carnetController.clear();
    _experienciaProfesionalController.clear();
    _experienciaAcademicaController.clear();

    // Asignar valores actuales
    _nombresController.text = docente.names ?? '';
    _apellidosController.text = docente.surnames ?? '';
    _emailController.text = docente.correoElectronico ?? '';
    _carnetController.text = docente.carnetIdentidad ?? '';
    _experienciaProfesionalController.text =
        docente.experienciaProfesional ?? '';
    _experienciaAcademicaController.text = docente.experienciaAcademica ?? '';

    // Establecer género
    if (docente.genero != null && docente.genero!.isNotEmpty) {
      _selectedGenero = docente.genero!;
    } else {
      _selectedGenero = 'Masculino'; // Valor por defecto
    }

    // Establecer fecha de nacimiento
    _selectedDate = docente.fechaNacimiento;

    // Forzar rebuild del widget para actualizar la UI
    setState(() {});

    print('Controladores inicializados:');
    print('Nombres: ${_nombresController.text}');
    print('Apellidos: ${_apellidosController.text}');
    print('Email: ${_emailController.text}');
    print('Carnet: ${_carnetController.text}');
    print('Experiencia Profesional: ${_experienciaProfesionalController.text}');
    print('Experiencia Académica: ${_experienciaAcademicaController.text}');
    print('Género: $_selectedGenero');
    print('Fecha: $_selectedDate');
  }

  Widget _buildDesktopActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: Colors.white),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff2350ba),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopSecondaryButton(
      String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: Color(0xff2350ba)),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff2350ba),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[100],
          foregroundColor: Color(0xff2350ba),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Color(0xff2350ba).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
