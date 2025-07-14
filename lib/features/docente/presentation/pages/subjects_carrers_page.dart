import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/carreras_asignadas_provider.dart';
import '../providers/asignaturas_asignadas_provider.dart';
import '../providers/solicitudes_provider.dart';
import '../providers/asignaturas_disponibles_provider.dart';
import '../providers/docente_provider.dart';
import '../providers/solicitudes_pendientes_provider.dart';
import '../../domain/entities/asignatura_disponible.dart';
import '../../domain/entities/solicitud_pendiente.dart';
import 'package:frontend_emi_sistema/core/constants/emi_colors.dart';

class SubjectsCarrersPage extends ConsumerStatefulWidget {
  const SubjectsCarrersPage({super.key});

  @override
  ConsumerState<SubjectsCarrersPage> createState() =>
      _SubjectsCarrersPageState();
}

class _SubjectsCarrersPageState extends ConsumerState<SubjectsCarrersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Cargar información personal del docente
      ref.read(docenteProvider.notifier).getPersonalInfo();

      // Cargar carreras y asignaturas asignadas
      await _loadCarrerasYAsignaturas();

      // Cargar solicitudes pendientes
      await _loadSolicitudesPendientes();

      // Esperar a que se cargue el docente y luego cargar estudios académicos
      await Future.delayed(Duration(milliseconds: 300));
      final docenteState = ref.read(docenteProvider);
      if (docenteState is DocenteSuccessState && docenteState.docente != null) {
        final docenteId = docenteState.docente!.docenteId;
        ref
            .read(estudiosAcademicosProvider.notifier)
            .getEstudiosAcademicos(docenteId: docenteId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSolicitudesPendientes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      if (token.isNotEmpty) {
        ref
            .read(solicitudesPendientesProvider.notifier)
            .getSolicitudesPendientes(token);
      }
    } catch (e) {
      print('Error al cargar solicitudes pendientes: $e');
    }
  }

  Future<void> _loadCarrerasYAsignaturas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      if (token.isNotEmpty) {
        ref
            .read(carrerasAsignadasProvider.notifier)
            .getCarrerasAsignadas(token);
        ref
            .read(asignaturasAsignadasProvider.notifier)
            .getAsignaturasAsignadas(token);
      }
    } catch (e) {
      print('Error al cargar carreras y asignaturas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final carrerasState = ref.watch(carrerasAsignadasProvider);
    final asignaturasState = ref.watch(asignaturasAsignadasProvider);
    final solicitudesPendientesState = ref.watch(solicitudesPendientesProvider);
    final solicitudesState = ref.watch(solicitudesProvider);

    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isDesktop
            ? Column(
                children: [
                  // Header elegante
                  _buildHeader(context),
                  SizedBox(height: 16),

                  // Botón de postulación
                  _buildPostulacionButton(context, solicitudesState),
                  SizedBox(height: 16),

                  // Contenido principal
                  Expanded(
                    child: _buildMainContent(
                      context,
                      carrerasState,
                      asignaturasState,
                      solicitudesPendientesState,
                    ),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () async {
                  final token = Preferences().userToken;

                  if (token.isEmpty) {
                    return;
                  }

                  // Refrescar todos los providers y esperar a que se completen
                  ref.invalidate(carrerasAsignadasProvider);
                  ref.invalidate(asignaturasAsignadasProvider);
                  ref.invalidate(solicitudesPendientesProvider);

                  // Esperar a que todos los providers se recarguen
                  await Future.wait([
                    ref
                        .read(carrerasAsignadasProvider.notifier)
                        .getCarrerasAsignadas(token),
                    ref
                        .read(asignaturasAsignadasProvider.notifier)
                        .getAsignaturasAsignadas(token),
                    ref
                        .read(solicitudesPendientesProvider.notifier)
                        .getSolicitudesPendientes(token),
                  ]);
                },
                color: EMIColors.primaryBlue,
                child: Column(
                  children: [
                    // Header elegante
                    _buildHeader(context),
                    SizedBox(height: 16),

                    // Botón de postulación
                    _buildPostulacionButton(context, solicitudesState),
                    SizedBox(height: 16),

                    // Contenido principal
                    Expanded(
                      child: _buildMainContent(
                        context,
                        carrerasState,
                        asignaturasState,
                        solicitudesPendientesState,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Container(
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
                        "Mis Carreras y Asignaturas",
                        style: TextStyle(
                          color: Color(0xff2350ba),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Consulta las carreras y asignaturas que tienes asignadas",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2350ba).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xff2350ba).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Docente",
                    style: TextStyle(
                      color: Color(0xff2350ba),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
                        "Mis Carreras y Asignaturas",
                        style: TextStyle(
                          color: Color(0xff2350ba),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff2350ba).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xff2350ba).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Docente",
                        style: TextStyle(
                          color: Color(0xff2350ba),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Consulta las carreras y asignaturas que tienes asignadas",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPostulacionButton(BuildContext context, SolicitudesState state) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: state is SolicitudesLoading
              ? null
              : () => _showPostulacionDialog(context),
          icon: state is SolicitudesLoading
              ? SizedBox(
                  width: isDesktop ? 18 : 16,
                  height: isDesktop ? 18 : 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: isDesktop ? 22 : 18,
                ),
          label: Text(
            state is SolicitudesLoading ? 'Procesando...' : 'Postular',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isDesktop ? 15 : 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff2350ba),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 14 : 12,
              horizontal: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context,
      CarrerasAsignadasState carrerasState,
      AsignaturasAsignadasState asignaturasState,
      SolicitudesPendientesState solicitudesPendientesState) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de Carreras
                Flexible(
                  child:
                      _buildCarrerasSection(context, carrerasState, isDesktop),
                ),
                SizedBox(width: 24),
                // Sección de Asignaturas
                Expanded(
                  child: _buildAsignaturasSection(
                      context, asignaturasState, isDesktop),
                ),
                SizedBox(width: 24),
                // Sección de Solicitudes Pendientes
                Expanded(
                  child: _buildSolicitudesPendientesSection(
                      context, solicitudesPendientesState, isDesktop),
                ),
              ],
            )
          : Column(
              children: [
                // Tab Bar para móvil
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: EMIColors.lightGray,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Color(0xff2350ba),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xff2350ba),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.school, size: 18),
                        text: 'Carreras',
                      ),
                      Tab(
                        icon: Icon(Icons.book, size: 18),
                        text: 'Asignaturas',
                      ),
                      Tab(
                        icon: Icon(Icons.pending_actions, size: 18),
                        text: 'Pendientes',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Tab Bar View
                Flexible(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Carreras
                      _buildCarrerasSection(context, carrerasState, isDesktop),
                      // Tab 2: Asignaturas
                      _buildAsignaturasSection(
                          context, asignaturasState, isDesktop),
                      // Tab 3: Solicitudes Pendientes
                      _buildSolicitudesPendientesSection(
                          context, solicitudesPendientesState, isDesktop),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCarrerasSection(
      BuildContext context, CarrerasAsignadasState state, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EMIColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección (solo en desktop)
          if (isDesktop)
            Container(
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xff2350ba).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.school,
                      color: Color(0xff2350ba),
                      size: isDesktop ? 20 : 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Carreras',
                          style: TextStyle(
                            color: Color(0xff2350ba),
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Solicitar asignación a una carrera específica',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff2350ba),
                    size: 16,
                  ),
                ],
              ),
            ),
          // Contenido de carreras
          Flexible(
            child: _buildCarrerasContent(context, state, isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildAsignaturasSection(
      BuildContext context, AsignaturasAsignadasState state, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EMIColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección (solo en desktop)
          if (isDesktop)
            Container(
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xff2350ba).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.book,
                      color: Color(0xff2350ba),
                      size: isDesktop ? 20 : 16,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mis Asignaturas',
                          style: TextStyle(
                            color: Color(0xff2350ba),
                            fontSize: isDesktop ? 18 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Solicitar asignación a una asignatura específica',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xff2350ba),
                    size: 16,
                  ),
                ],
              ),
            ),
          // Contenido de asignaturas
          Flexible(
            child: _buildAsignaturasContent(context, state, isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrerasContent(
      BuildContext context, CarrerasAsignadasState state, bool isDesktop) {
    if (state is CarrerasAsignadasInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              color: Colors.grey[400],
              size: isDesktop ? 48 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'No hay carreras asignadas',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cuando te asignen carreras, aparecerán aquí.',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: isDesktop ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is CarrerasAsignadasLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff2350ba)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando carreras...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is CarrerasAsignadasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: isDesktop ? 48 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar carreras',
              style: TextStyle(
                color: Colors.red,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is CarrerasAsignadasSuccess) {
      if (state.carreras.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school_outlined,
                color: Colors.grey[400],
                size: isDesktop ? 48 : 40,
              ),
              SizedBox(height: 16),
              Text(
                'No tienes carreras asignadas',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cuando te asignen carreras, aparecerán aquí.',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isDesktop ? 14 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 12),
        child: Column(
          children: state.carreras.map((carrera) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: EMIColors.lightGray,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EMIColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.school,
                      color: EMIColors.primaryBlue,
                      size: isDesktop ? 20 : 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      carrera.carreraNombre,
                      style: TextStyle(
                        color: EMIColors.darkGray,
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    // Estado desconocido
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            color: Colors.grey[400],
            size: isDesktop ? 48 : 40,
          ),
          SizedBox(height: 16),
          Text(
            'Estado desconocido',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isDesktop ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAsignaturasContent(
      BuildContext context, AsignaturasAsignadasState state, bool isDesktop) {
    if (state is AsignaturasAsignadasInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              color: Colors.grey[400],
              size: isDesktop ? 48 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'No hay asignaturas asignadas',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cuando te asignen asignaturas, aparecerán aquí.',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: isDesktop ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is AsignaturasAsignadasLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff374151)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando asignaturas...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is AsignaturasAsignadasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: isDesktop ? 48 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar asignaturas',
              style: TextStyle(
                color: Colors.red,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is AsignaturasAsignadasSuccess) {
      if (state.asignaturas.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.book_outlined,
                color: Colors.grey[400],
                size: isDesktop ? 48 : 40,
              ),
              SizedBox(height: 16),
              Text(
                'No tienes asignaturas asignadas',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cuando te asignen asignaturas, aparecerán aquí.',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isDesktop ? 14 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 12),
        child: Column(
          children: state.asignaturas.map((asignatura) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: EMIColors.lightGray,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: EMIColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.book,
                      color: EMIColors.primaryBlue,
                      size: isDesktop ? 20 : 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      asignatura.asignaturaNombre,
                      style: TextStyle(
                        color: EMIColors.darkGray,
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    // Estado desconocido
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            color: Colors.grey[400],
            size: isDesktop ? 48 : 40,
          ),
          SizedBox(height: 16),
          Text(
            'Estado desconocido',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isDesktop ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesPendientesSection(
      BuildContext context, SolicitudesPendientesState state, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: EMIColors.lightGray,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección (solo en desktop)
          if (isDesktop)
            Container(
              padding: EdgeInsets.all(isDesktop ? 20 : 16),
              decoration: BoxDecoration(
                color: EMIColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.pending_actions_rounded,
                    color: Color(0xff2350ba),
                    size: isDesktop ? 24 : 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Solicitudes Pendientes',
                    style: TextStyle(
                      color: Color(0xff2350ba),
                      fontSize: isDesktop ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          // Contenido de solicitudes pendientes
          Flexible(
            child:
                _buildSolicitudesPendientesContent(context, state, isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesPendientesContent(
      BuildContext context, SolicitudesPendientesState state, bool isDesktop) {
    if (state is SolicitudesPendientesLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff374151)),
            ),
            SizedBox(height: 16),
            Text(
              'Cargando solicitudes pendientes...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 16 : 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is SolicitudesPendientesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: isDesktop ? 48 : 40,
            ),
            SizedBox(height: 16),
            Text(
              'Error al cargar solicitudes pendientes',
              style: TextStyle(
                color: Colors.red,
                fontSize: isDesktop ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is SolicitudesPendientesSuccess) {
      if (state.solicitudes.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.pending_actions_outlined,
                color: Colors.grey[400],
                size: isDesktop ? 48 : 40,
              ),
              SizedBox(height: 16),
              Text(
                'No tienes solicitudes pendientes',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Cuando tengas solicitudes pendientes, aparecerán aquí.',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isDesktop ? 14 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(isDesktop ? 20 : 12),
        itemCount: state.solicitudes.length,
        itemBuilder: (context, index) {
          final solicitud = state.solicitudes[index];
          return Container(
            margin: EdgeInsets.only(bottom: isDesktop ? 12 : 8),
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              color: EMIColors.veryLightGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: EMIColors.lightGray,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      solicitud.tipoSolicitud == 'carrera'
                          ? Icons.school
                          : Icons.book,
                      color: EMIColors.primaryBlue,
                      size: isDesktop ? 20 : 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Solicitud de ${solicitud.tipoSolicitud}',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: EMIColors.darkGray,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _getSolicitudDetalle(solicitud),
                  style: TextStyle(
                    color: EMIColors.mediumGray,
                    fontSize: isDesktop ? 14 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: EMIColors.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: EMIColors.primaryBlue.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        solicitud.estadoNombre,
                        style: TextStyle(
                          color: EMIColors.primaryBlue,
                          fontSize: isDesktop ? 12 : 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _formatDate(solicitud.creadoEn),
                      style: TextStyle(
                        color: EMIColors.mediumGray,
                        fontSize: isDesktop ? 12 : 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    // Estado inicial o desconocido
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions_outlined,
            color: Colors.grey[400],
            size: isDesktop ? 48 : 40,
          ),
          SizedBox(height: 16),
          Text(
            'Cargando solicitudes pendientes...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isDesktop ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getSolicitudDetalle(SolicitudPendiente solicitud) {
    if (solicitud.tipoSolicitud == 'carrera' &&
        solicitud.carreraNombre != null) {
      return 'Carrera: ${solicitud.carreraNombre}';
    } else if (solicitud.tipoSolicitud == 'asignatura' &&
        solicitud.asignaturaNombre != null) {
      return 'Asignatura: ${solicitud.asignaturaNombre}';
    }
    return 'Sin detalle';
  }

  void _showPostulacionDialog(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    if (isDesktop) {
      // Usar diálogo para desktop
      _showPostulacionDialogDesktop(context);
    } else {
      // Usar BottomSheet para móviles/tablets
      _showPostulacionBottomSheet(context);
    }
  }

  void _showPostulacionDialogDesktop(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff2350ba),
                      Color(0xff1E40AF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Seleccionar Tipo de Postulación',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Opción para postular a carrera
              Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xff2350ba).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      _showCarrerasDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xff2350ba).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school,
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
                                  'Postular a Carrera',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2350ba),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Solicitar asignación a una carrera específica',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff2350ba),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Opción para postular a asignatura
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Color(0xff374151).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                      _showAsignaturasDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xff374151).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.book,
                              color: Color(0xff374151),
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Postular a Asignatura',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff374151),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Solicitar asignación a una asignatura específica',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff374151),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Botón cancelar
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostulacionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle para arrastrar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff2350ba),
                    Color(0xff1E40AF),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
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
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Seleccionar Tipo de Postulación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Opción para postular a carrera
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xff2350ba).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCarrerasDialog(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff2350ba).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
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
                                'Postular a Carrera',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff2350ba),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Solicitar asignación a una carrera específica',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff2350ba),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Opción para postular a asignatura
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xff374151).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showAsignaturasDialog(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff374151).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.book,
                            color: Color(0xff374151),
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Postular a Asignatura',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff374151),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Solicitar asignación a una asignatura específica',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff374151),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Botón cancelar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Espacio extra para evitar que el contenido se corte
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCarrerasDialog(BuildContext context) async {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    if (isDesktop) {
      _showCarrerasDialogDesktop(context);
    } else {
      _showCarrerasBottomSheet(context);
    }
  }

  void _showCarrerasDialogDesktop(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: No se encontró el token de autenticación')),
      );
      return;
    }

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final carrerasAsync = ref.watch(carrerasProvider);
          final carrerasAsignadasState = ref.watch(carrerasAsignadasProvider);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 450, // Ancho reducido
              height: 600,
              padding: EdgeInsets.all(24),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.school,
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
                              'Postular a Carrera',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            Text(
                              'Selecciona una carrera para postular',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Lista de carreras
                  Expanded(
                    child: carrerasAsync.when(
                      data: (carreras) {
                        // Obtener carreras asignadas para comparar
                        List<String> carrerasAsignadasIds = [];
                        if (carrerasAsignadasState
                            is CarrerasAsignadasSuccess) {
                          carrerasAsignadasIds = carrerasAsignadasState.carreras
                              .map((c) => c.carreraId)
                              .toList();
                        }

                        return ListView.builder(
                          itemCount: carreras.length,
                          itemBuilder: (context, index) {
                            final carrera = carreras[index];
                            final yaAsociado = carrerasAsignadasIds
                                .contains(carrera.id.toString());

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color:
                                    yaAsociado ? Colors.grey[50] : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: yaAsociado
                                      ? Colors.grey[300]!
                                      : Color(0xff2350ba)
                                          .withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: yaAsociado
                                      ? null
                                      : () {
                                          Navigator.of(context).pop();
                                          _postularCarrera(token, carrera.id);
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: yaAsociado
                                                ? Colors.grey[200]
                                                : Color(0xff2350ba)
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            yaAsociado
                                                ? Icons.check_circle
                                                : Icons.school,
                                            color: yaAsociado
                                                ? Colors.grey[600]
                                                : Color(0xff2350ba),
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                carrera.nombre,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: yaAsociado
                                                      ? Colors.grey[600]
                                                      : Color(0xff2350ba),
                                                ),
                                              ),
                                              if (yaAsociado) ...[
                                                SizedBox(height: 4),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green[100],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Text(
                                                    'Ya asociado',
                                                    style: TextStyle(
                                                      color: Colors.green[700],
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        if (!yaAsociado)
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xff2350ba),
                                            size: 16,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff2350ba)),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Cargando carreras...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error al cargar carreras',
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCarrerasBottomSheet(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: No se encontró el token de autenticación')),
      );
      return;
    }

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final carrerasAsync = ref.watch(carrerasProvider);
          final carrerasAsignadasState = ref.watch(carrerasAsignadasProvider);

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle para arrastrar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff2350ba),
                        Color(0xff1E40AF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                              'Postular a Carrera',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Selecciona una carrera para postular',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista de carreras
                Expanded(
                  child: carrerasAsync.when(
                    data: (carreras) {
                      // Obtener carreras asignadas para comparar
                      List<String> carrerasAsignadasIds = [];
                      if (carrerasAsignadasState is CarrerasAsignadasSuccess) {
                        carrerasAsignadasIds = carrerasAsignadasState.carreras
                            .map((c) => c.carreraId)
                            .toList();
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: carreras.length,
                        itemBuilder: (context, index) {
                          final carrera = carreras[index];
                          final yaAsociado = carrerasAsignadasIds
                              .contains(carrera.id.toString());

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  yaAsociado ? Colors.grey[50] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: yaAsociado
                                    ? Colors.grey[300]!
                                    : Color(0xff2350ba).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: yaAsociado
                                    ? null
                                    : () {
                                        Navigator.of(context).pop();
                                        _postularCarrera(token, carrera.id);
                                      },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: yaAsociado
                                              ? Colors.grey[200]
                                              : Color(0xff2350ba)
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          yaAsociado
                                              ? Icons.check_circle
                                              : Icons.school,
                                          color: yaAsociado
                                              ? Colors.grey[600]
                                              : Color(0xff2350ba),
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              carrera.nombre,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: yaAsociado
                                                    ? Colors.grey[600]
                                                    : Color(0xff2350ba),
                                              ),
                                            ),
                                            if (yaAsociado) ...[
                                              SizedBox(height: 4),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[100],
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Ya asociado',
                                                  style: TextStyle(
                                                    color: Colors.green[700],
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (!yaAsociado)
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xff2350ba),
                                          size: 16,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff2350ba)),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Cargando carreras...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Error al cargar carreras',
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

                // Espacio extra para evitar que el contenido se corte
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAsignaturasDialog(BuildContext context) async {
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    if (isDesktop) {
      _showAsignaturasDialogDesktop(context);
    } else {
      _showAsignaturasBottomSheet(context);
    }
  }

  void _showAsignaturasDialogDesktop(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: No se encontró el token de autenticación')),
      );
      return;
    }

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final asignaturasState = ref.watch(asignaturasDisponiblesProvider);
          final asignaturasAsignadasState =
              ref.watch(asignaturasAsignadasProvider);

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 550, // Ancho reducido
              height: 700,
              padding: EdgeInsets.all(24),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xff374151).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.book,
                          color: Color(0xff374151),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Postular a Asignatura',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff374151),
                              ),
                            ),
                            Text(
                              'Selecciona una asignatura para postular',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Contenido
                  Expanded(
                    child: asignaturasState is AsignaturasDisponiblesLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xff374151)),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Cargando asignaturas...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : asignaturasState is AsignaturasDisponiblesError
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Error al cargar asignaturas',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      asignaturasState.message,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : asignaturasState is AsignaturasDisponiblesSuccess
                                ? _buildAsignaturasDisponiblesList(
                                    asignaturasState.asignaturas,
                                    asignaturasAsignadasState)
                                : Center(
                                    child: Text(
                                      'No hay asignaturas disponibles',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                  ),

                  SizedBox(height: 20),

                  // Botón cancelar
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAsignaturasBottomSheet(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    if (token.isEmpty) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: No se encontró el token de autenticación')),
      );
      return;
    }

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final asignaturasState = ref.watch(asignaturasDisponiblesProvider);
          final asignaturasAsignadasState =
              ref.watch(asignaturasAsignadasProvider);

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle para arrastrar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff374151),
                        Color(0xff1F2937),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
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
                          Icons.book,
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
                              'Postular a Asignatura',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Selecciona una asignatura para postular',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido
                Expanded(
                  child: asignaturasState is AsignaturasDisponiblesLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff374151)),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Cargando asignaturas...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : asignaturasState is AsignaturasDisponiblesError
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Error al cargar asignaturas',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    asignaturasState.message,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : asignaturasState is AsignaturasDisponiblesSuccess
                              ? _buildAsignaturasDisponiblesList(
                                  asignaturasState.asignaturas,
                                  asignaturasAsignadasState)
                              : Center(
                                  child: Text(
                                    'No hay asignaturas disponibles',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                ),

                // Espacio extra para evitar que el contenido se corte
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAsignaturasDisponiblesList(
      Map<String, List<AsignaturaDisponible>> asignaturasPorCarrera,
      AsignaturasAsignadasState asignaturasAsignadasState) {
    // Obtener asignaturas asignadas para comparar
    List<String> asignaturasAsignadasIds = [];
    if (asignaturasAsignadasState is AsignaturasAsignadasSuccess) {
      asignaturasAsignadasIds = asignaturasAsignadasState.asignaturas
          .map((a) => a.asignaturaId)
          .toList();
    }

    if (asignaturasPorCarrera.isEmpty) {
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
                Icons.book_outlined,
                color: Colors.grey[400],
                size: 48,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'No hay asignaturas disponibles',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Intenta más tarde',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: asignaturasPorCarrera.length,
      itemBuilder: (context, index) {
        final carreraNombre = asignaturasPorCarrera.keys.elementAt(index);
        final asignaturasCarrera = asignaturasPorCarrera[carreraNombre]!;

        return ExpansionTile(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff374151).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.school,
                  color: Color(0xff374151),
                  size: 16,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  carreraNombre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff374151),
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          children: asignaturasCarrera.map((asignatura) {
            final yaAsociado =
                asignaturasAsignadasIds.contains(asignatura.id.toString());

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: yaAsociado ? Colors.grey[50] : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: yaAsociado
                      ? Colors.grey[300]!
                      : Color(0xff374151).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: yaAsociado
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          _postularAsignatura(asignatura.id);
                        },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: yaAsociado
                                ? Colors.grey[200]
                                : Color(0xff374151).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            yaAsociado ? Icons.check_circle : Icons.book,
                            color: yaAsociado
                                ? Colors.grey[600]
                                : Color(0xff374151),
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                asignatura.materia,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: yaAsociado
                                      ? Colors.grey[600]
                                      : Color(0xff374151),
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: yaAsociado
                                          ? Colors.grey[200]
                                          : Color(0xff374151)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      asignatura.semestres,
                                      style: TextStyle(
                                        color: yaAsociado
                                            ? Colors.grey[600]
                                            : Color(0xff374151),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: yaAsociado
                                          ? Colors.grey[200]
                                          : Color(0xff374151)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      asignatura.gestion.toString(),
                                      style: TextStyle(
                                        color: yaAsociado
                                            ? Colors.grey[600]
                                            : Color(0xff374151),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (yaAsociado) ...[
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Ya asociado',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!yaAsociado)
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff374151),
                            size: 14,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _postularCarrera(String token, int carreraId) async {
    try {
      await ref
          .read(solicitudesProvider.notifier)
          .crearSolicitud(token, 'carrera', carreraId);

      final solicitudesState = ref.read(solicitudesProvider);
      if (solicitudesState is SolicitudesSuccess) {
        // ignore: use_build_context_synchronously
        _showSuccessDialog(
            // ignore: use_build_context_synchronously
            context,
            'Carrera',
            'Solicitud de carrera enviada exitosamente');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorDialog(context, _cleanErrorMessage(e.toString()));
    }
  }

  void _postularAsignatura(int asignaturaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      await ref
          .read(solicitudesProvider.notifier)
          .crearSolicitud(token, 'asignatura', asignaturaId);

      final solicitudesState = ref.read(solicitudesProvider);
      if (solicitudesState is SolicitudesSuccess) {
        // ignore: use_build_context_synchronously
        _showSuccessDialog(context, 'Asignatura',
            'Solicitud de asignatura enviada exitosamente');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorDialog(context, _cleanErrorMessage(e.toString()));
    }
  }

  String _cleanErrorMessage(String errorMessage) {
    // Remover "Exception: " del inicio del mensaje
    if (errorMessage.startsWith('Exception: ')) {
      return errorMessage.substring('Exception: '.length);
    }
    return errorMessage;
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400, // Ancho reducido
            padding: EdgeInsets.all(24),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de error con animación
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),

                // Título
                Text(
                  'No se pudo completar la solicitud',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),

                // Mensaje de error
                Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Botón de cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Entendido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String tipo, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 400, // Ancho reducido
            padding: EdgeInsets.all(24),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de éxito
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green[600],
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),

                // Título
                Text(
                  '¡Solicitud enviada!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),

                // Mensaje de éxito
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),

                // Botón de cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Entendido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
