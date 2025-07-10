import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/info_row_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/estudios_academicos_section_widget.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';

class DesktopDetallesPanelWidget extends ConsumerWidget {
  final Docente docente;
  const DesktopDetallesPanelWidget({super.key, required this.docente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  color: Color(0xff2350ba).withValues(alpha: 0.1),
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
                      color: Color(0xff2350ba).withValues(alpha: 0.15),
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
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
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
                  InfoRowWidget(label: 'Nombres', value: docente.names),
                  InfoRowWidget(label: 'Apellidos', value: docente.surnames),
                  InfoRowWidget(
                      label: 'ID Docente', value: docente.docenteId.toString()),
                  if (docente.carreraNombre != null)
                    InfoRowWidget(
                        label: 'Carrera', value: docente.carreraNombre!),
                  InfoRowWidget(
                      label: 'Estado',
                      value: docente.estadoNombre ?? 'No especificado'),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Estudios académicos
            EstudiosAcademicosSectionWidget(),
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
}
