import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/carreras_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/carrera_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/carrera_details_panel.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/empty_carrera_panel.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/carrera.dart';

// Provider para la carrera seleccionada en desktop
final selectedCarreraProvider = StateProvider<Carrera?>((ref) => null);

void showCarreraDetailsBottomSheet(BuildContext context, Carrera carrera) {
  print('DEBUG: Abriendo bottom sheet para carrera: ${carrera.nombre}');
  print('DEBUG: Asignaturas en la carrera: ${carrera.asignaturas.length}');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      print('DEBUG: Construyendo CarreraDetailsPanel');
      return CarreraDetailsPanel(carrera: carrera);
    },
  ).then((_) {
    print('DEBUG: Bottom sheet cerrado');
  }).catchError((error) {
    print('DEBUG: Error en bottom sheet: $error');
  });
}

class CarrerasPage extends ConsumerStatefulWidget {
  const CarrerasPage({super.key});

  @override
  ConsumerState<CarrerasPage> createState() => _CarrerasPageState();
}

class _CarrerasPageState extends ConsumerState<CarrerasPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Carrera> _filteredCarreras = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCarreras);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCarreras() {
    final carrerasAsync = ref.read(carrerasProvider(Preferences().userToken));
    carrerasAsync.whenData((carreras) {
      final query = _searchController.text.toLowerCase().trim();
      setState(() {
        if (query.isEmpty) {
          _filteredCarreras = carreras;
        } else {
          _filteredCarreras = carreras.where((carrera) {
            final nombre = _normalizeText(carrera.nombre);
            final normalizedQuery = _normalizeText(query);
            return nombre.contains(normalizedQuery);
          }).toList();
        }
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final String token = Preferences().userToken;

    if (token.isEmpty) {
      return Center(child: Text('No hay token de autenticación'));
    }

    return Consumer(
      builder: (context, ref, child) {
        final carrerasAsync = ref.watch(carrerasProvider(token));
        final selectedCarrera = ref.watch(selectedCarreraProvider);
        final selectedCarreraNotifier =
            ref.read(selectedCarreraProvider.notifier);

        return carrerasAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16),
                Text(
                  'Error al cargar las carreras',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          data: (carreras) {
            // Inicializar las carreras filtradas si está vacío
            if (_filteredCarreras.isEmpty) {
              _filteredCarreras = carreras;
            }

            if (carreras.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay carreras registradas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Las carreras aparecerán aquí cuando se registren en el sistema',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Seleccionar la primera carrera por defecto en desktop
            if (selectedCarrera == null && _filteredCarreras.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                selectedCarreraNotifier.state = _filteredCarreras[0];
              });
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;

                return Container(
                  color: Colors.white,
                  child: isDesktop
                      ? Row(
                          children: [
                            // Sidebar
                            CarrerasSideBar(
                              carreras: _filteredCarreras,
                              selectedCarrera: selectedCarrera,
                              onCarreraSelected: (carrera) {
                                selectedCarreraNotifier.state = carrera;
                              },
                              searchController: _searchController,
                            ),
                            // Panel de detalles para desktop
                            Expanded(
                              child: selectedCarrera != null
                                  ? CarreraDetailsPanel(
                                      carrera: selectedCarrera, isDesktop: true)
                                  : EmptyCarreraPanel(),
                            ),
                          ],
                        )
                      : // Mobile/tablet: diseño mejorado con navegación directa
                      Column(
                          children: [
                            // Header con búsqueda
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xff2350ba)
                                        .withValues(alpha: 0.08),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Título
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.school,
                                        color: Color(0xff2350ba),
                                        size: 24,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Carreras',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff2350ba),
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${_filteredCarreras.length} de ${carreras.length} carreras',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  // Barra de búsqueda
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
                                        hintText:
                                            'Buscar carrera por nombre...',
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Color(0xff2350ba),
                                        ),
                                        suffixIcon: _searchController
                                                .text.isNotEmpty
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
                                ],
                              ),
                            ),
                            // Lista de carreras
                            Expanded(
                              child: _filteredCarreras.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _searchController.text.isEmpty
                                                ? Icons.school_outlined
                                                : Icons.search_off,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            _searchController.text.isEmpty
                                                ? 'No hay carreras'
                                                : 'No se encontraron carreras',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            _searchController.text.isEmpty
                                                ? 'Las carreras aparecerán aquí cuando se registren en el sistema'
                                                : 'No hay carreras que coincidan con "${_searchController.text}"',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemCount: _filteredCarreras.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final carrera =
                                            _filteredCarreras[index];
                                        return CarreraWidget(
                                          carrera: carrera,
                                          onTap: () {
                                            // Mostrar detalles de la carrera
                                            print(
                                                'DEBUG: Haciendo clic en carrera: ${carrera.nombre}');
                                            print(
                                                'DEBUG: Número de asignaturas: ${carrera.asignaturas.length}');
                                            showCarreraDetailsBottomSheet(
                                                context, carrera);
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class CarrerasSideBar extends StatelessWidget {
  final List<Carrera> carreras;
  final Carrera? selectedCarrera;
  final Function(Carrera) onCarreraSelected;
  final TextEditingController searchController;

  const CarrerasSideBar({
    super.key,
    required this.carreras,
    required this.selectedCarrera,
    required this.onCarreraSelected,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: Color(0xff2350ba).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Header del sidebar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xff2350ba).withValues(alpha: 0.05),
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
                    Icon(
                      Icons.school,
                      color: Color(0xff2350ba),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Carreras',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2350ba),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xff2350ba),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${carreras.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Buscador para desktop
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
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar carrera por nombre...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff2350ba),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.grey[600]),
                              onPressed: () {
                                searchController.clear();
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
              ],
            ),
          ),
          // Lista de carreras
          Expanded(
            child: carreras.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchController.text.isEmpty
                              ? Icons.school_outlined
                              : Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          searchController.text.isEmpty
                              ? 'No hay carreras'
                              : 'No se encontraron carreras',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          searchController.text.isEmpty
                              ? 'Las carreras aparecerán aquí cuando se registren'
                              : 'No hay carreras que coincidan con "${searchController.text}"',
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
                    itemCount: carreras.length,
                    itemBuilder: (context, index) {
                      final carrera = carreras[index];
                      final isSelected = selectedCarrera?.id == carrera.id;

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: CarreraWidget(
                          carrera: carrera,
                          isSelected: isSelected,
                          onTap: () {
                            onCarreraSelected(carrera);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
