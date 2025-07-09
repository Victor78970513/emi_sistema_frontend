import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/personal_info_header.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/personal_information_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

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
                    color: Colors.black.withOpacity(0.05),
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
                color: Colors.black.withOpacity(0.05),
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
                  color: Colors.red.withOpacity(0.1),
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
                'No se pudo obtener la información personal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
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
                color: Colors.black.withOpacity(0.05),
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
                  color: Colors.grey.withOpacity(0.1),
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
            child: _buildProfileCard(context, docente, true),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xff4A90E2),
        elevation: 0,
        title: Text(
          'Información Personal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showEditProfileModal(context, docente),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff4A90E2),
                    Color(0xff5BA0F2),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Avatar del docente
                      DocenteImage(docente: docente),
                      SizedBox(height: 16),
                      Text(
                        docente.names,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        docente.surnames,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'ID: ${docente.docenteId}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Botones de acción en grid
                  Container(
                    padding: EdgeInsets.all(16),
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
                      children: [
                        Text(
                          'Acciones Rápidas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMobileActionButton(
                                'Editar',
                                Icons.edit,
                                () => _showEditProfileModal(context, docente),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildMobileActionButton(
                                'Foto',
                                Icons.camera_alt,
                                () => _selectAndUploadPhoto(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: _buildMobileActionButton(
                        //         'Estudios',
                        //         Icons.school,
                        //         () => print('Ver estudios'),
                        //       ),
                        //     ),
                        //     SizedBox(width: 12),
                        //     Expanded(
                        //       child: _buildMobileActionButton(
                        //         'CV',
                        //         Icons.download,
                        //         () => print('Descargar CV'),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Secciones de información
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff4A90E2),
            Color(0xff5BA0F2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xff4A90E2).withOpacity(0.3),
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
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
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
          SizedBox(height: 12),
          _buildActionButton(
            'Ver Estudios',
            Icons.school,
            () {
              // TODO: Navegar a estudios
              print('Ver estudios');
            },
            isDesktop,
          ),
          SizedBox(height: 12),
          _buildActionButton(
            'Descargar CV',
            Icons.download,
            () {
              // TODO: Implementar descarga de CV
              print('Descargar CV');
            },
            isDesktop,
          ),

          Spacer(),

          // Información de estado
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Información del Perfil',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
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
    return Container(
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
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileActionButton(
      String text, IconData icon, VoidCallback onPressed) {
    return Container(
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
          backgroundColor: Color(0xff4A90E2),
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

    showDialog(
      context: context,
      barrierDismissible: false, // Evitar que se cierre al tocar fuera
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(maxWidth: 500),
                child: Column(
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
                            Color(0xff4A90E2),
                            Color(0xff5BA0F2),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
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
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                            _buildModernEditField(
                                'Apellidos',
                                _apellidosController,
                                Icons.person,
                                'Ingresa tus apellidos'),
                            SizedBox(height: 20),
                            _buildModernEditField('Email', _emailController,
                                Icons.email, 'Ingresa tu email'),
                            SizedBox(height: 20),
                            _buildModernEditField(
                                'Carnet de Identidad',
                                _carnetController,
                                Icons.badge,
                                'Ingresa tu carnet',
                                TextInputType.number),
                            SizedBox(height: 20),
                            _buildModernDropdownField(
                                'Género',
                                _selectedGenero,
                                _generos,
                                Icons.person_outline, (String? newValue) {
                              setModalState(() {
                                _updateGenero(newValue);
                              });
                            }),
                            SizedBox(height: 20),
                            _buildModernDateField('Fecha de Nacimiento',
                                _selectedDate, Icons.calendar_today, () async {
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
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Color(0xff4A90E2)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Color(0xff4A90E2),
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
                                  _updateProfileAndClose(dialogContext),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff4A90E2),
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
                                  Icon(Icons.save,
                                      size: 20, color: Colors.white),
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                color: Color(0xff4A90E2).withOpacity(0.1),
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
                color: Color(0xff4A90E2).withOpacity(0.1),
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
                color: Color(0xff4A90E2).withOpacity(0.1),
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
                color: Colors.white.withOpacity(0.7),
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
            color: Color(0xff4A90E2).withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow('Email', docente.email, Icons.email, Colors.blue),
          _buildInfoRow(
              'Carnet de Identidad',
              docente.identificationCard.isNotEmpty
                  ? docente.identificationCard
                  : 'No especificado',
              Icons.badge,
              Colors.green),
          _buildInfoRow(
              'Género',
              docente.gender.isNotEmpty ? docente.gender : 'No especificado',
              Icons.person,
              Colors.purple),
          _buildInfoRow(
              'Fecha de Nacimiento',
              docente.dateOfBirth != null
                  ? docente.dateOfBirth.toString()
                  : 'No especificado',
              Icons.calendar_today,
              Colors.orange),
          _buildInfoRow(
              'Foto del Docente',
              docente.docenteImagePath.isNotEmpty
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
              color: color.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildExperienceCard(
            'Experiencia Profesional',
            docente.yearsOfWorkExperience != null
                ? '${docente.yearsOfWorkExperience} años'
                : 'No especificado',
            Icons.work,
            Colors.blue,
          ),
          SizedBox(height: 16),
          _buildExperienceCard(
            'Experiencia Académica',
            docente.semestersOfTeachingExperience != null
                ? '${docente.semestersOfTeachingExperience} semestres'
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
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
              'Categoría Docente',
              docente.teacherCategoryId != null
                  ? 'Categoría ${docente.teacherCategoryId}'
                  : 'No especificado',
              Icons.category,
              Colors.purple),
          _buildInfoRow(
              'Modalidad de Ingreso',
              docente.entryModeId != null
                  ? 'Modalidad ${docente.entryModeId}'
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
              primary: Color(0xff4A90E2),
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
  Future<void> _updateProfileAndClose(BuildContext dialogContext) async {
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
      Navigator.of(dialogContext).pop();

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
    _emailController.text = docente.email ?? '';
    _carnetController.text = docente.identificationCard ?? '';
    _experienciaProfesionalController.text =
        (docente.yearsOfWorkExperience ?? 0).toString();
    _experienciaAcademicaController.text =
        (docente.semestersOfTeachingExperience ?? 0).toString();

    // Establecer género
    if (docente.gender != null && docente.gender.isNotEmpty) {
      _selectedGenero = docente.gender;
    } else {
      _selectedGenero = 'Masculino'; // Valor por defecto
    }

    // Establecer fecha de nacimiento
    _selectedDate = docente.dateOfBirth;

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
}
