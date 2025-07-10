import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/estudios_academicos_section_widget.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';

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
                  DocenteImage(
                    docente: docente,
                    radius: 50,
                    backgroundColor: Color(0xff2350ba).withValues(alpha: 0.15),
                    textColor: Color(0xff2350ba),
                    showBorder: true,
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
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Color(0xfff8fafc),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xffe2e8f0),
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff2350ba),
                              Color(0xff1e40af),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.person,
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
                              'Información Personal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xff2350ba),
                              ),
                            ),
                            Text(
                              'Datos básicos del docente',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Información en filas compactas
                  Column(
                    children: [
                      // Información básica
                      _CompactInfoRow(
                        icon: Icons.person_outline,
                        label: 'Nombres',
                        value: docente.names,
                        color: Color(0xff3b82f6),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.person_outline,
                        label: 'Apellidos',
                        value: docente.surnames,
                        color: Color(0xff3b82f6),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.badge,
                        label: 'ID Docente',
                        value: docente.docenteId.toString(),
                        color: Color(0xff10b981),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.credit_card,
                        label: 'Carnet de Identidad',
                        value: docente.carnetIdentidad?.isNotEmpty == true
                            ? docente.carnetIdentidad!
                            : 'No especificado',
                        color: Color(0xff8b5cf6),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.email,
                        label: 'Correo Electrónico',
                        value: docente.correoElectronico?.isNotEmpty == true
                            ? docente.correoElectronico!
                            : 'No especificado',
                        color: Color(0xff06b6d4),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.wc,
                        label: 'Género',
                        value: docente.genero?.isNotEmpty == true
                            ? docente.genero!
                            : 'No especificado',
                        color: Color(0xffec4899),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.cake,
                        label: 'Fecha de Nacimiento',
                        value: docente.fechaNacimiento != null
                            ? docente.fechaNacimiento.toString().split('T')[0]
                            : 'No especificado',
                        color: Color(0xfff59e0b),
                      ),
                      SizedBox(height: 12),
                      if (docente.carreraNombre != null) ...[
                        _CompactInfoRow(
                          icon: Icons.school,
                          label: 'Carrera',
                          value: docente.carreraNombre!,
                          color: Color(0xfff59e0b),
                        ),
                        SizedBox(height: 12),
                      ],
                      _CompactInfoRow(
                        icon: Icons.verified,
                        label: 'Estado',
                        value: docente.estadoNombre ?? 'No especificado',
                        color: docente.estadoNombre == 'aprobado'
                            ? Color(0xff10b981)
                            : Color(0xfff59e0b),
                        isStatus: true,
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.category,
                        label: 'Categoría Docente',
                        value: docente.categoriaNombre?.isNotEmpty == true
                            ? docente.categoriaNombre!
                            : 'No especificado',
                        color: Color(0xff6366f1),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.login,
                        label: 'Modalidad de Ingreso',
                        value:
                            docente.modalidadIngresoNombre?.isNotEmpty == true
                                ? docente.modalidadIngresoNombre!
                                : 'No especificado',
                        color: Color(0xff84cc16),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.work,
                        label: 'Experiencia Profesional',
                        value:
                            docente.experienciaProfesional?.isNotEmpty == true
                                ? docente.experienciaProfesional!
                                : 'No especificado',
                        color: Color(0xffef4444),
                      ),
                      SizedBox(height: 12),
                      _CompactInfoRow(
                        icon: Icons.school,
                        label: 'Experiencia Académica',
                        value: docente.experienciaAcademica?.isNotEmpty == true
                            ? docente.experienciaAcademica!
                            : 'No especificado',
                        color: Color(0xff0891b2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            // Estudios académicos
            EstudiosAcademicosSectionWidget(),
            SizedBox(height: 32),
            // Acciones
            // Container(
            //   padding: const EdgeInsets.all(24),
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topLeft,
            //       end: Alignment.bottomRight,
            //       colors: [
            //         Colors.white,
            //         Color(0xfff8fafc),
            //       ],
            //     ),
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(
            //       color: Color(0xffe2e8f0),
            //       width: 1,
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withValues(alpha: 0.05),
            //         blurRadius: 10,
            //         offset: Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Header de la sección
            //       Row(
            //         children: [
            //           Container(
            //             padding: EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               gradient: LinearGradient(
            //                 colors: [
            //                   Color(0xff2350ba),
            //                   Color(0xff1e40af),
            //                 ],
            //               ),
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             child: Icon(
            //               Icons.settings,
            //               color: Colors.white,
            //               size: 24,
            //             ),
            //           ),
            //           SizedBox(width: 16),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Acciones',
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 22,
            //                     color: Color(0xff2350ba),
            //                   ),
            //                 ),
            //                 Text(
            //                   'Gestionar información del docente',
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color: Colors.grey[600],
            //                     fontWeight: FontWeight.w400,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 24),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: Color(0xff2350ba).withValues(alpha: 0.2),
            //                     blurRadius: 8,
            //                     offset: Offset(0, 4),
            //                   ),
            //                 ],
            //               ),
            //               child: ElevatedButton.icon(
            //                 onPressed: () {
            //                   // Implementar editar
            //                 },
            //                 icon: Icon(Icons.edit, size: 20),
            //                 label: Text('Editar Docente'),
            //                 style: ElevatedButton.styleFrom(
            //                   backgroundColor: Color(0xff2350ba),
            //                   foregroundColor: Colors.white,
            //                   padding: EdgeInsets.symmetric(vertical: 16),
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(12),
            //                   ),
            //                   elevation: 0,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 16),
            //           Expanded(
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(12),
            //                 boxShadow: [
            //                   BoxShadow(
            //                     color: Colors.grey.withValues(alpha: 0.2),
            //                     blurRadius: 8,
            //                     offset: Offset(0, 4),
            //                   ),
            //                 ],
            //               ),
            //               child: OutlinedButton.icon(
            //                 onPressed: () {
            //                   // Implementar ver más
            //                 },
            //                 icon: Icon(Icons.visibility, size: 20),
            //                 label: Text('Ver más detalles'),
            //                 style: OutlinedButton.styleFrom(
            //                   foregroundColor: Color(0xff2350ba),
            //                   side: BorderSide(
            //                       color: Color(0xff2350ba), width: 2),
            //                   padding: EdgeInsets.symmetric(vertical: 16),
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(12),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CompactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isStatus;

  const _CompactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xffe2e8f0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
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
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          if (isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: color,
                  width: 1,
                ),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
