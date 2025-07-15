import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/carrera.dart';
import '../../domain/entities/asignatura.dart';
import 'asignatura_detalle_panel.dart';

void showAsignaturaDetalleBottomSheet(
    BuildContext context, String asignaturaId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AsignaturaDetallePanel(asignaturaId: asignaturaId),
  );
}

class CarreraDetailsPanel extends StatefulWidget {
  final Carrera carrera;
  final bool isDesktop;

  const CarreraDetailsPanel({
    super.key,
    required this.carrera,
    this.isDesktop = false,
  });

  @override
  State<CarreraDetailsPanel> createState() => _CarreraDetailsPanelState();
}

class _CarreraDetailsPanelState extends State<CarreraDetailsPanel> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gestionController = TextEditingController();
  final TextEditingController _semestreController = TextEditingController();
  List<Asignatura> _filteredAsignaturas = [];

  @override
  void initState() {
    super.initState();
    _filteredAsignaturas = widget.carrera.asignaturas;
    _searchController.addListener(_filterAsignaturas);
    _gestionController.addListener(_filterAsignaturas);
    _semestreController.addListener(_filterAsignaturas);
  }

  @override
  void didUpdateWidget(CarreraDetailsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió la carrera, limpiar filtros y actualizar lista
    if (oldWidget.carrera.id != widget.carrera.id) {
      _clearAllFilters();
      _filteredAsignaturas = widget.carrera.asignaturas;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _gestionController.dispose();
    _semestreController.dispose();
    super.dispose();
  }

  void _filterAsignaturas() {
    final nameQuery = _normalizeText(_searchController.text.trim());
    final gestionQuery = _normalizeText(_gestionController.text.trim());
    final semestreQuery = _normalizeText(_semestreController.text.trim());

    setState(() {
      if (nameQuery.isEmpty && gestionQuery.isEmpty && semestreQuery.isEmpty) {
        _filteredAsignaturas = widget.carrera.asignaturas;
      } else {
        _filteredAsignaturas = widget.carrera.asignaturas.where((asignatura) {
          final materia = _normalizeText(asignatura.materia);
          final gestion = _normalizeText(asignatura.gestion.toString());
          final semestres = _normalizeText(asignatura.semestres);

          bool matchesName = nameQuery.isEmpty || materia.contains(nameQuery);
          bool matchesGestion =
              gestionQuery.isEmpty || gestion.contains(gestionQuery);
          bool matchesSemestre =
              semestreQuery.isEmpty || semestres.contains(semestreQuery);

          return matchesName && matchesGestion && matchesSemestre;
        }).toList();
      }
    });
  }

  void _clearAllFilters() {
    _searchController.clear();
    _gestionController.clear();
    _semestreController.clear();
  }

  String _normalizeText(String text) {
    return text
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('à', 'a')
        .replaceAll('è', 'e')
        .replaceAll('ì', 'i')
        .replaceAll('ò', 'o')
        .replaceAll('ù', 'u');
  }

  bool _hasActiveFilters() {
    return _searchController.text.isNotEmpty ||
        _gestionController.text.isNotEmpty ||
        _semestreController.text.isNotEmpty;
  }

  String _getFilterMessage() {
    final filters = <String>[];
    if (_searchController.text.isNotEmpty) {
      filters.add('nombre: "${_searchController.text}"');
    }
    if (_gestionController.text.isNotEmpty) {
      filters.add('gestión: "${_gestionController.text}"');
    }
    if (_semestreController.text.isNotEmpty) {
      filters.add('semestre: "${_semestreController.text}"');
    }

    if (filters.isEmpty) return '';
    return 'No hay asignaturas que coincidan con ${filters.join(", ")}';
  }

  @override
  Widget build(BuildContext context) {
    print(
        'DEBUG: Construyendo CarreraDetailsPanel para: ${widget.carrera.nombre}');
    print('DEBUG: Número de asignaturas: ${widget.carrera.asignaturas.length}');

    if (widget.isDesktop) {
      // Layout para desktop
      return Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // Header para desktop
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff2350ba).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.school,
                          color: Color(0xff2350ba),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.carrera.nombre,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${_filteredAsignaturas.length} de ${widget.carrera.asignaturas.length} asignaturas',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          final url =
                              '${Constants.baseUrl}api/admin/carreras/${widget.carrera.id}/asignaturas/pdf';
                          try {
                            await launchUrl(Uri.parse(url),
                                mode: LaunchMode.externalApplication);
                          } catch (e) {
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                  content: Text('Error al abrir el PDF: $e')),
                            );
                          }
                        },
                        icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                        label: Text('Descargar reporte',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2350ba),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Filtros para desktop
                  Row(
                    children: [
                      // Buscador por nombre
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por nombre...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xff2350ba),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear,
                                          color: Colors.grey[600]),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Filtro por gestión
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _gestionController,
                          decoration: InputDecoration(
                            hintText: 'Gestión',
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Color(0xff2350ba),
                              size: 20,
                            ),
                            suffixIcon: _gestionController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey[600], size: 18),
                                    onPressed: () {
                                      _gestionController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Filtro por semestre
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _semestreController,
                          decoration: InputDecoration(
                            hintText: 'Semestre',
                            prefixIcon: Icon(
                              Icons.grade,
                              color: Color(0xff2350ba),
                              size: 20,
                            ),
                            suffixIcon: _semestreController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey[600], size: 18),
                                    onPressed: () {
                                      _semestreController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Botón para limpiar todos los filtros
                      if (_searchController.text.isNotEmpty ||
                          _gestionController.text.isNotEmpty ||
                          _semestreController.text.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2350ba),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: _clearAllFilters,
                            icon: Icon(
                              Icons.clear_all,
                              color: Colors.white,
                              size: 20,
                            ),
                            tooltip: 'Limpiar filtros',
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Contenido para desktop
            Expanded(
              child: _filteredAsignaturas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            !_hasActiveFilters()
                                ? Icons.book_outlined
                                : Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            !_hasActiveFilters()
                                ? 'No hay asignaturas'
                                : 'No se encontraron asignaturas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            !_hasActiveFilters()
                                ? 'Esta carrera no tiene asignaturas registradas'
                                : _getFilterMessage(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(24),
                      itemCount: _filteredAsignaturas.length,
                      itemBuilder: (context, index) {
                        final asignatura = _filteredAsignaturas[index];
                        print(
                            'DEBUG: Construyendo asignatura: ${asignatura.materia}');
                        return AsignaturaCard(
                          asignatura: asignatura,
                          onTap: () {
                            // Navegar a la página de detalles en desktop
                            context.push('/admin/asignatura/${asignatura.id}');
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    } else {
      // Layout para mobile/tablet (bottom sheet)
      return Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header para mobile
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba).withValues(alpha: 0.15),
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
                              widget.carrera.nombre,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${_filteredAsignaturas.length} de ${widget.carrera.asignaturas.length} asignaturas',
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
                  SizedBox(height: 16),
                  // Filtros para mobile
                  Column(
                    children: [
                      // Buscador por nombre
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar por nombre...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xff2350ba),
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey[600]),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 12),
                      // Filtros adicionales en fila
                      Row(
                        children: [
                          // Filtro por gestión
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _gestionController,
                                decoration: InputDecoration(
                                  hintText: 'Gestión',
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: Color(0xff2350ba),
                                    size: 20,
                                  ),
                                  suffixIcon: _gestionController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(Icons.clear,
                                              color: Colors.grey[600],
                                              size: 18),
                                          onPressed: () {
                                            _gestionController.clear();
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Filtro por semestre
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: _semestreController,
                                decoration: InputDecoration(
                                  hintText: 'Semestre',
                                  prefixIcon: Icon(
                                    Icons.grade,
                                    color: Color(0xff2350ba),
                                    size: 20,
                                  ),
                                  suffixIcon:
                                      _semestreController.text.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.clear,
                                                  color: Colors.grey[600],
                                                  size: 18),
                                              onPressed: () {
                                                _semestreController.clear();
                                              },
                                            )
                                          : null,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Botón para limpiar todos los filtros
                          if (_searchController.text.isNotEmpty ||
                              _gestionController.text.isNotEmpty ||
                              _semestreController.text.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff2350ba),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _clearAllFilters,
                                icon: Icon(
                                  Icons.clear_all,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: 'Limpiar filtros',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Contenido para mobile
            Expanded(
              child: _filteredAsignaturas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            !_hasActiveFilters()
                                ? Icons.book_outlined
                                : Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            !_hasActiveFilters()
                                ? 'No hay asignaturas'
                                : 'No se encontraron asignaturas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            !_hasActiveFilters()
                                ? 'Esta carrera no tiene asignaturas registradas'
                                : _getFilterMessage(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredAsignaturas.length,
                      itemBuilder: (context, index) {
                        final asignatura = _filteredAsignaturas[index];
                        print(
                            'DEBUG: Construyendo asignatura: ${asignatura.materia}');
                        return AsignaturaCard(
                          asignatura: asignatura,
                          onTap: () {
                            // Mostrar bottom sheet en mobile
                            showAsignaturaDetalleBottomSheet(
                                context, asignatura.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }
  }
}

class AsignaturaCard extends StatelessWidget {
  final Asignatura asignatura;
  final VoidCallback? onTap;

  const AsignaturaCard({
    super.key,
    required this.asignatura,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título de la asignatura con indicador de click
              Row(
                children: [
                  Expanded(
                    child: Text(
                      asignatura.materia,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Información de la asignatura
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: 'Gestión ${asignatura.gestion}',
                    color: Colors.blue,
                  ),
                  SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.schedule,
                    label: "Periodo ${asignatura.periodo}",
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.grade,
                    label: asignatura.semestres,
                    color: Colors.orange,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.timer,
                    label: 'Carga horaria: ${asignatura.cargaHoraria} horas',
                    color: Colors.purple,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
