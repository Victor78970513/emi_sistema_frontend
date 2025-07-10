import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/utils/show_details_panel_bottom_sheet.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/docente_widget.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/selected_docente_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/desktop_detalles_panel_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/empty_desktop_panel_widget.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';

class DocentesPage extends ConsumerWidget {
  const DocentesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(docenteProvider);
        final selectedIndex = ref.watch(selectedDocenteProvider);
        final selectedNotifier = ref.read(selectedDocenteProvider.notifier);

        print('DocentesPage: Estado actual del docenteProvider: $state');

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;

            if (state is DocenteLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is DocenteErrorState) {
              return Center(child: Text('Error al cargar los docentes'));
            }
            if (state is DocenteSuccessState && state.docentes != null) {
              final docentes = state.docentes!;
              print(
                  'DocentesPage: Número de docentes cargados: ${docentes.length}');

              if (docentes.isEmpty) {
                return Center(child: Text('No hay docentes registrados.'));
              }
              if (selectedIndex == null && docentes.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  selectedNotifier.state = 0;
                });
              }
              return Container(
                color: Colors.white,
                child: isDesktop
                    ? Row(
                        children: [
                          // Sidebar
                          DocentesSideBar(docentes: docentes),
                          // Panel de detalles para desktop
                          Expanded(
                            child: selectedIndex != null &&
                                    selectedIndex < docentes.length
                                ? DesktopDetallesPanelWidget(
                                    docente: docentes[selectedIndex])
                                : EmptyDesktopPanelWidget(),
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
                                  color:
                                      Color(0xff2350ba).withValues(alpha: 0.08),
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
                                      Icons.people,
                                      color: Color(0xff2350ba),
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Docentes',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2350ba),
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${docentes.length} docentes',
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
                                TextField(
                                  decoration: InputDecoration(
                                    hintText:
                                        'Buscar docente por nombre o ID...',
                                    prefixIcon: Icon(Icons.search,
                                        color: Color(0xff2350ba)),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Color(0xff2350ba),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(fontSize: 16),
                                  onChanged: (value) {
                                    // Implementar búsqueda aquí
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Lista de docentes
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: docentes.length,
                              separatorBuilder: (_, __) => SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final docente = docentes[index];
                                final isSelected = selectedIndex == index;
                                return GestureDetector(
                                  onTap: () {
                                    selectedNotifier.state = index;
                                    showDetallesPanelBottomSheet(
                                        context, docente, ref);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xff2350ba)
                                              .withValues(alpha: 0.08)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? Color(0xff2350ba)
                                            : Colors.grey[200]!,
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Avatar
                                        DocenteImage(
                                          docente: docente,
                                          radius: 30,
                                          backgroundColor: Color(0xff2350ba)
                                              .withValues(alpha: 0.15),
                                          textColor: Color(0xff2350ba),
                                        ),
                                        SizedBox(width: 16),
                                        // Información del docente
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${docente.names} ${docente.surnames}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: isSelected
                                                      ? Color(0xff2350ba)
                                                      : Colors.black87,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'ID: ${docente.docenteId}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              if (docente.carreraNombre !=
                                                  null) ...[
                                                SizedBox(height: 2),
                                                Text(
                                                  docente.carreraNombre!,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        // Estado
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: docente.estadoNombre ==
                                                    'aprobado'
                                                ? Colors.green
                                                    .withValues(alpha: 0.1)
                                                : Colors.orange
                                                    .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: docente.estadoNombre ==
                                                      'aprobado'
                                                  ? Colors.green
                                                  : Colors.orange,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            docente.estadoNombre ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: docente.estadoNombre ==
                                                      'aprobado'
                                                  ? Colors.green
                                                  : Colors.orange,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        // Icono de flecha para indicar que es navegable
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.grey[400],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              );
            }
            print(
                'DocentesPage - Estado no manejado, retornando SizedBox.shrink');
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
