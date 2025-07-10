import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/carreras_asignadas_provider.dart';
import '../providers/asignaturas_asignadas_provider.dart';
import '../providers/solicitudes_provider.dart';
import '../providers/asignaturas_disponibles_provider.dart';
import '../providers/docente_provider.dart';
import '../../domain/entities/asignatura_disponible.dart';

class SubjectsCarrersPage extends ConsumerStatefulWidget {
  const SubjectsCarrersPage({super.key});

  @override
  ConsumerState<SubjectsCarrersPage> createState() =>
      _SubjectsCarrersPageState();
}

class _SubjectsCarrersPageState extends ConsumerState<SubjectsCarrersPage> {
  @override
  Widget build(BuildContext context) {
    final carrerasState = ref.watch(carrerasAsignadasProvider);
    final asignaturasState = ref.watch(asignaturasAsignadasProvider);
    final solicitudesState = ref.watch(solicitudesProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        return Container(
          color: Colors.white,
          child: Column(
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
                              Icons.subject_rounded,
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
                              color: Color(0xff2350ba),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Docente",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
                                  Icons.subject_rounded,
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
                                  color: Color(0xff2350ba),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "Docente",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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
              ),
              // SizedBox(height: isDesktop ? 25 : 16),

              // Botón de postulación
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 16,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: solicitudesState is SolicitudesLoading
                        ? null
                        : () => _showPostulacionDialog(context),
                    icon: solicitudesState is SolicitudesLoading
                        ? SizedBox(
                            width: isDesktop ? 20 : 18,
                            height: isDesktop ? 20 : 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            Icons.add_circle_outline,
                            color: Colors.white,
                            size: isDesktop ? 24 : 20,
                          ),
                    label: Text(
                      solicitudesState is SolicitudesLoading
                          ? 'Procesando...'
                          : 'Postular',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isDesktop ? 16 : 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2350ba),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 16 : 14,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 25 : 12),

              // Contenido principal
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 16,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sección de Carreras
                            Expanded(
                              child: _buildCarrerasSection(
                                  context, carrerasState, isDesktop),
                            ),
                            SizedBox(width: 24),
                            // Sección de Asignaturas
                            Expanded(
                              child: _buildAsignaturasSection(
                                  context, asignaturasState, isDesktop),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            // Sección de Carreras
                            _buildCarrerasSection(
                                context, carrerasState, isDesktop),
                            SizedBox(height: 16),
                            // Sección de Asignaturas
                            Expanded(
                              child: _buildAsignaturasSection(
                                  context, asignaturasState, isDesktop),
                            ),
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

  Widget _buildCarrerasSection(
      BuildContext context, CarrerasAsignadasState state, bool isDesktop) {
    return Container(
      height: isDesktop ? null : 200, // Altura fija en móviles
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Container(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            decoration: BoxDecoration(
              color: Color(0xff2350ba).withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Color(0xff2350ba),
                  size: isDesktop ? 24 : 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Mis Carreras',
                  style: TextStyle(
                    color: Color(0xff2350ba),
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Contenido de carreras
          Expanded(
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
          color: Color(0xff374151).withValues(alpha: 0.2),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de la sección
          Container(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            decoration: BoxDecoration(
              color: Color(0xff374151).withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.book_rounded,
                  color: Color(0xff374151),
                  size: isDesktop ? 24 : 20,
                ),
                SizedBox(width: 12),
                Text(
                  'Mis Asignaturas',
                  style: TextStyle(
                    color: Color(0xff374151),
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Contenido de asignaturas
          Expanded(
            child: _buildAsignaturasContent(context, state, isDesktop),
          ),
        ],
      ),
    );
  }

  Widget _buildCarrerasContent(
      BuildContext context, CarrerasAsignadasState state, bool isDesktop) {
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
                'Usa el botón "Postular a Carrera" para solicitar una asignación',
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
        itemCount: state.carreras.length,
        itemBuilder: (context, index) {
          final carrera = state.carreras[index];
          return Container(
            margin: EdgeInsets.only(bottom: isDesktop ? 12 : 8),
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xff2350ba).withValues(alpha: 0.2),
                width: 1,
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
                  child: Text(
                    carrera.carreraNombre,
                    style: TextStyle(
                      color: Color(0xff2350ba),
                      fontSize: isDesktop ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Center(
      child: Text(
        'Estado desconocido',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: isDesktop ? 16 : 14,
        ),
      ),
    );
  }

  Widget _buildAsignaturasContent(
      BuildContext context, AsignaturasAsignadasState state, bool isDesktop) {
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
                'Usa el botón "Postular a Asignatura" para solicitar una asignación',
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
        itemCount: state.asignaturas.length,
        itemBuilder: (context, index) {
          final asignatura = state.asignaturas[index];
          return Container(
            margin: EdgeInsets.only(bottom: isDesktop ? 12 : 8),
            padding: EdgeInsets.all(isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xff374151).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xff374151).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.book,
                        color: Color(0xff374151),
                        size: isDesktop ? 20 : 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        asignatura.asignaturaNombre,
                        style: TextStyle(
                          color: Color(0xff374151),
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (isDesktop) ...[
                  SizedBox(height: 8),
                  _buildInfoItem(
                    context,
                    'ID',
                    asignatura.asignaturaId,
                    isDesktop,
                  ),
                  _buildInfoItem(
                    context,
                    'Gestión',
                    asignatura.gestion.toString(),
                    isDesktop,
                  ),
                  _buildInfoItem(
                    context,
                    'Periodo',
                    asignatura.periodo,
                    isDesktop,
                  ),
                  _buildInfoItem(
                    context,
                    'Semestres',
                    asignatura.semestres,
                    isDesktop,
                  ),
                ] else ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xff374151).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          asignatura.gestion.toString(),
                          style: TextStyle(
                            color: Color(0xff374151),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xff374151).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          asignatura.periodo,
                          style: TextStyle(
                            color: Color(0xff374151),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xff374151).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          asignatura.semestres,
                          style: TextStyle(
                            color: Color(0xff374151),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    }

    return Center(
      child: Text(
        'Estado desconocido',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: isDesktop ? 16 : 14,
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, bool isDesktop) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isDesktop ? 80 : 70,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: isDesktop ? 14 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: isDesktop ? 14 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPostulacionDialog(BuildContext context) {
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

  void _showCarrerasDialog(BuildContext context) async {
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

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 500,
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
                            Icons.school,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Seleccionar Carrera',
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
                  SizedBox(height: 20),

                  // Contenido
                  Expanded(
                    child: carrerasAsync.when(
                      data: (carreras) => carreras.isEmpty
                          ? Center(
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
                                      Icons.school_outlined,
                                      color: Colors.grey[400],
                                      size: 48,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No hay carreras disponibles',
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
                            )
                          : ListView.builder(
                              itemCount: carreras.length,
                              itemBuilder: (context, index) {
                                final carrera = carreras[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xff2350ba)
                                          .withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
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
                                                color: Color(0xff2350ba)
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Icon(
                                                Icons.school,
                                                color: Color(0xff2350ba),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff2350ba),
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
                                );
                              },
                            ),
                      loading: () => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff2350ba)),
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Cargando carreras...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
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

  void _showAsignaturasDialog(BuildContext context) async {
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

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 600,
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
                children: [
                  // Header
                  Container(
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
                          child: Text(
                            'Seleccionar Asignatura',
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
                  SizedBox(height: 20),

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
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Cargando asignaturas...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
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
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.red[50],
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 48,
                                      ),
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
                                ? asignaturasState.asignaturas.isEmpty
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(16),
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
                                      )
                                    : _buildAsignaturasDisponiblesList(
                                        asignaturasState.asignaturas)
                                : Center(
                                    child: Text(
                                    'No hay asignaturas disponibles',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  )),
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

  Widget _buildAsignaturasDisponiblesList(
      Map<String, List<AsignaturaDisponible>> asignaturas) {
    return ListView.builder(
      itemCount: asignaturas.length,
      itemBuilder: (context, index) {
        final carreraNombre = asignaturas.keys.elementAt(index);
        final asignaturasCarrera = asignaturas[carreraNombre]!;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xff374151).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ExpansionTile(
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
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Color(0xff374151).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
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
                              color: Color(0xff374151).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.book,
                              color: Color(0xff374151),
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
                                    color: Color(0xff374151),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Color(0xff374151)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        asignatura.semestres,
                                        style: TextStyle(
                                          color: Color(0xff374151),
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
                                        color: Color(0xff374151)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        asignatura.gestion.toString(),
                                        style: TextStyle(
                                          color: Color(0xff374151),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
          ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud de carrera enviada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar solicitud: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitud de asignatura enviada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al enviar solicitud: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
