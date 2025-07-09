import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/utils/show_details_panel_bottom_sheet.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/docente_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/docentes_header.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/selected_docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';

class DocentesPage extends ConsumerWidget {
  const DocentesPage({super.key});

  // Función para descargar/abrir PDF
  Future<void> _downloadPdf(String documentoUrl) async {
    try {
      final url =
          "${Constants.baseUrl}api/docente/estudios-academicos/$documentoUrl/pdf";
      // 'http://localhost:3000/api/docente/estudios-academicos/$documentoUrl/pdf';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo abrir la URL';
      }
    } catch (e) {
      print('Error al descargar PDF: $e');
      // Aquí podrías mostrar un snackbar o dialog con el error
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(docenteProvider);
    final selectedIndex = ref.watch(selectedDocenteProvider);
    final selectedNotifier = ref.read(selectedDocenteProvider.notifier);

    // Debug: imprimir el estado actual
    print('DocentesPage - Estado actual: $state');
    print('DocentesPage - selectedIndex: $selectedIndex');

    if (state is DocenteSuccessState) {
      print(
          'DocentesPage - Número de docentes: ${state.docentes?.length ?? 0}');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        print(
            'DocentesPage - isDesktop: $isDesktop, maxWidth: ${constraints.maxWidth}');

        if (state is DocenteLoadingState) {
          print('DocentesPage - Mostrando loading');
          return Center(child: CircularProgressIndicator());
        }
        if (state is DocenteErrorState) {
          print('DocentesPage - Mostrando error');
          return Center(child: Text('Error al cargar los docentes'));
        }
        if (state is DocenteSuccessState && state.docentes != null) {
          final docentes = state.docentes!;
          print('DocentesPage - Docentes cargados: ${docentes.length}');

          if (docentes.isEmpty) {
            print('DocentesPage - No hay docentes');
            return Center(child: Text('No hay docentes registrados.'));
          }

          // Selección por defecto si no hay selección
          if (selectedIndex == null && docentes.isNotEmpty) {
            print('DocentesPage - Estableciendo selección por defecto');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              selectedNotifier.state = 0;
            });
          }

          print('DocentesPage - Renderizando UI principal');
          return Container(
            color: Colors.white,
            child: isDesktop
                ? Row(
                    children: [
                      // Sidebar
                      Container(
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border(
                            right: BorderSide(
                              color: Color(0xff2350ba).withOpacity(0.08),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(24, 24, 24, 12),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Buscar docente o ID',
                                  prefixIcon: Icon(Icons.search,
                                      color: Color(0xff2350ba)),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Color(0xff2350ba)
                                            .withOpacity(0.15)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Color(0xff2350ba)
                                            .withOpacity(0.10)),
                                  ),
                                ),
                                style: TextStyle(fontSize: 15),
                                onChanged: (value) {
                                  // Aquí puedes implementar búsqueda si lo deseas
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.only(bottom: 24),
                                itemCount: docentes.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 2),
                                itemBuilder: (context, index) {
                                  final docente = docentes[index];
                                  final isSelected = selectedIndex == index;
                                  return GestureDetector(
                                    onTap: () => selectedNotifier.state = index,
                                    child: Container(
                                      color: isSelected
                                          ? Color(0xff2350ba).withOpacity(0.08)
                                          : Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xff2350ba)
                                                .withOpacity(0.15),
                                            child: Text(
                                              docente.names.isNotEmpty
                                                  ? docente.names[0]
                                                      .toUpperCase()
                                                  : '?',
                                              style: TextStyle(
                                                color: Color(0xff2350ba),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 14),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${docente.names} ${docente.surnames}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: isSelected
                                                        ? Color(0xff2350ba)
                                                        : Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  'ID: ${docente.docenteId}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                if (docente.carreraNombre !=
                                                    null)
                                                  Text(
                                                    docente.carreraNombre!,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[500],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Text(
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
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Panel de detalles para desktop
                      Expanded(
                        child: selectedIndex != null &&
                                selectedIndex! < docentes.length
                            ? _buildDesktopDetallesPanel(
                                docentes[selectedIndex!], ref)
                            : _buildEmptyDesktopPanel(),
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
                              color: Color(0xff2350ba).withOpacity(0.08),
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
                                hintText: 'Buscar docente por nombre o ID...',
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
                                // Navegar al panel de detalles
                                _showDetallesPanel(context, docente, ref);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Color(0xff2350ba).withOpacity(0.08)
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
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xff2350ba).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: Text(
                                          docente.names.isNotEmpty
                                              ? docente.names[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color: Color(0xff2350ba),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
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
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color:
                                              docente.estadoNombre == 'aprobado'
                                                  ? Colors.green
                                                  : Colors.orange,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        docente.estadoNombre ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              docente.estadoNombre == 'aprobado'
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
        print('DocentesPage - Estado no manejado, retornando SizedBox.shrink');
        return const SizedBox.shrink();
      },
    );
  }

  void _showDetallesPanel(
      BuildContext context, Docente docente, WidgetRef ref) {
    // Cargar los estudios académicos cuando se abre el panel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(estudiosAcademicosProvider.notifier)
          .getEstudiosAcademicos(docenteId: docente.docenteId);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
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
              // Header con botón de cerrar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Detalles del Docente',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2350ba),
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              // Contenido del panel
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header del docente
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(0xff2350ba).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Avatar grande
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Color(0xff2350ba).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Text(
                                  docente.names.isNotEmpty
                                      ? docente.names[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: Color(0xff2350ba),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            // Información principal
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${docente.names} ${docente.surnames}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'ID: ${docente.docenteId}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: docente.estadoNombre == 'aprobado'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.orange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color:
                                            docente.estadoNombre == 'aprobado'
                                                ? Colors.green
                                                : Colors.orange,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      docente.estadoNombre ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                            docente.estadoNombre == 'aprobado'
                                                ? Colors.green
                                                : Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // Información detallada
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información Personal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            SizedBox(height: 16),
                            _buildInfoRow('Nombres', docente.names),
                            _buildInfoRow('Apellidos', docente.surnames),
                            _buildInfoRow(
                                'ID Docente', docente.docenteId.toString()),
                            if (docente.carreraNombre != null)
                              _buildInfoRow('Carrera', docente.carreraNombre!),
                            _buildInfoRow('Estado',
                                docente.estadoNombre ?? 'No especificado'),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // Estudios académicos
                      _buildEstudiosAcademicosSection(),
                      SizedBox(height: 24),
                      // Acciones
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Acciones',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Implementar editar
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.edit, size: 18),
                                    label: Text('Editar'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff2350ba),
                                      foregroundColor: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // Implementar ver más
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.visibility, size: 18),
                                    label: Text('Ver más'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Color(0xff2350ba),
                                      side:
                                          BorderSide(color: Color(0xff2350ba)),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
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
                      SizedBox(height: 20),
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

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xff2350ba),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEstudiosAcademicosSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(estudiosAcademicosProvider);

        if (state is EstudiosAcademicosLoadingState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xff2350ba),
              ),
            ),
          );
        }

        if (state is EstudiosAcademicosErrorState) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Error al cargar estudios académicos',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (state is EstudiosAcademicosSuccessState) {
          final estudios = state.estudios;

          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Color(0xff2350ba),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Estudios Académicos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff2350ba),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${estudios.length} estudios',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (estudios.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No hay estudios académicos registrados',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: estudios.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final estudio = estudios[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Color(0xff2350ba),
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    estudio.titulo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            _buildEstudioInfoRow(
                                'Institución', estudio.institucionNombre),
                            _buildEstudioInfoRow(
                                'Grado', estudio.gradoAcademicoNombre),
                            _buildEstudioInfoRow(
                                'Año', estudio.anioTitulacion.toString()),
                            if (estudio.documentoUrl.isNotEmpty) ...[
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Documento: ${estudio.documentoUrl}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _downloadPdf(estudio.documentoUrl);
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      color: Color(0xff2350ba),
                                      size: 18,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey[100],
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildEstudioInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopDetallesPanel(Docente docente, WidgetRef ref) {
    // Cargar los estudios académicos cuando se selecciona un docente
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(estudiosAcademicosProvider.notifier)
          .getEstudiosAcademicos(docenteId: docente.docenteId);
    });

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del docente
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xff2350ba).withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Avatar grande
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff2350ba).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        docente.names.isNotEmpty
                            ? docente.names[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Color(0xff2350ba),
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${docente.names} ${docente.surnames}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ID: ${docente.docenteId}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: docente.estadoNombre == 'aprobado'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: docente.estadoNombre == 'aprobado'
                                  ? Colors.green
                                  : Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            docente.estadoNombre ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: docente.estadoNombre == 'aprobado'
                                  ? Colors.green
                                  : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Información detallada
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información Personal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff2350ba),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDesktopInfoRow('Nombres', docente.names),
                  _buildDesktopInfoRow('Apellidos', docente.surnames),
                  _buildDesktopInfoRow(
                      'ID Docente', docente.docenteId.toString()),
                  if (docente.carreraNombre != null)
                    _buildDesktopInfoRow('Carrera', docente.carreraNombre!),
                  _buildDesktopInfoRow(
                      'Estado', docente.estadoNombre ?? 'No especificado'),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Estudios académicos
            _buildDesktopEstudiosAcademicosSection(),
            SizedBox(height: 32),
            // Acciones
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acciones',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff2350ba),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Implementar editar
                          },
                          icon: Icon(Icons.edit, size: 20),
                          label: Text('Editar Docente'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff2350ba),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Implementar ver más
                          },
                          icon: Icon(Icons.visibility, size: 20),
                          label: Text('Ver más detalles'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xff2350ba),
                            side: BorderSide(color: Color(0xff2350ba)),
                            padding: EdgeInsets.symmetric(vertical: 16),
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
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDesktopPanel() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 120,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24),
            Text(
              'Selecciona un docente',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Elige un docente de la lista para ver sus detalles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopEstudiosAcademicosSection() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(estudiosAcademicosProvider);

        if (state is EstudiosAcademicosLoadingState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xff2350ba),
              ),
            ),
          );
        }

        if (state is EstudiosAcademicosErrorState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                'Error al cargar estudios académicos',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        if (state is EstudiosAcademicosSuccessState) {
          final estudios = state.estudios;

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Estudios Académicos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff2350ba),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${estudios.length} estudios',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (estudios.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No hay estudios académicos registrados',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: estudios.length,
                    separatorBuilder: (_, __) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final estudio = estudios[index];
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Color(0xff2350ba),
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    estudio.titulo,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            _buildDesktopEstudioInfoRow(
                                'Institución', estudio.institucionNombre),
                            _buildDesktopEstudioInfoRow(
                                'Grado', estudio.gradoAcademicoNombre),
                            _buildDesktopEstudioInfoRow(
                                'Año', estudio.anioTitulacion.toString()),
                            if (estudio.documentoUrl.isNotEmpty) ...[
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Colors.grey[600],
                                    size: 18,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Documento: ${estudio.documentoUrl}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _downloadPdf(estudio.documentoUrl);
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      color: Color(0xff2350ba),
                                      size: 18,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey[100],
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildDesktopEstudioInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
