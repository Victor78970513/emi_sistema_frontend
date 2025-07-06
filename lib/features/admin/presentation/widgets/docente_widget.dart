import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/shared/widgets/modern_button.dart';

class DocenteWidget extends ConsumerWidget {
  final Docente docente;
  const DocenteWidget({super.key, required this.docente});

  void _showDocenteInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _DocenteInfoDialog(docente: docente),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        final titleTextStyle = TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

        return Container(
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 8 : 6,
            horizontal: isDesktop ? 24 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 16 : 12, horizontal: isDesktop ? 20 : 16),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: isDesktop ? 60 : 50,
                      child: CircleAvatar(
                        radius: isDesktop ? 25 : 20,
                        backgroundColor:
                            Color(0xff2350ba).withValues(alpha: 0.15),
                        child: Text(
                          docente.names.isNotEmpty
                              ? docente.names[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Color(0xff2350ba),
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                      ),
                    ),
                    // Nombre
                    Expanded(
                      flex: 2,
                      child: Text(
                        docente.names,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Apellido
                    Expanded(
                      flex: 2,
                      child: Text(
                        docente.surnames,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Email
                    Expanded(
                      flex: 3,
                      child: Text(
                        docente.email,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Carrera
                    Expanded(
                      flex: 2,
                      child: Text(
                        docente.carreraNombre ?? 'N/A',
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Estado
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: docente.estadoNombre == 'aprobado'
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: docente.estadoNombre == 'aprobado'
                                  ? Colors.green
                                  : Colors.orange,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            docente.estadoNombre ?? 'N/A',
                            style: TextStyle(
                              color: docente.estadoNombre == 'aprobado'
                                  ? Colors.green
                                  : Colors.orange,
                              fontSize: isDesktop ? 12 : 10,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Botón de acción
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          Expanded(
                            child: ModernButton(
                              text: "Ver Información",
                              backgroundColor: Color(0xff2350ba),
                              onPressed: () => _showDocenteInfo(context),
                              isDesktop: isDesktop,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Diálogo para mostrar información detallada del docente
class _DocenteInfoDialog extends StatelessWidget {
  final Docente docente;

  const _DocenteInfoDialog({required this.docente});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xff2350ba).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person,
              color: Color(0xff2350ba),
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Información del Docente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff2350ba),
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(label: 'ID Docente:', value: docente.docenteId.toString()),
            _InfoRow(label: 'Nombres:', value: docente.names),
            _InfoRow(label: 'Apellidos:', value: docente.surnames),
            _InfoRow(label: 'Correo:', value: docente.email),
            _InfoRow(
                label: 'Carnet de Identidad:',
                value: docente.identificationCard ?? 'No especificado'),
            _InfoRow(
                label: 'Género:', value: docente.gender ?? 'No especificado'),
            _InfoRow(
                label: 'Carrera:',
                value: docente.carreraNombre ?? 'No especificado'),
            _InfoRow(
                label: 'Estado:',
                value: docente.estadoNombre ?? 'No especificado'),
            _InfoRow(
                label: 'Experiencia Profesional:',
                value: docente.yearsOfWorkExperience?.toString() ??
                    'No especificado'),
            _InfoRow(
                label: 'Experiencia Académica:',
                value: docente.semestersOfTeachingExperience?.toString() ??
                    'No especificado'),
            _InfoRow(
                label: 'Categoría Docente:',
                value:
                    docente.teacherCategoryId?.toString() ?? 'No especificado'),
            _InfoRow(
                label: 'Modalidad de Ingreso:',
                value: docente.entryModeId?.toString() ?? 'No especificado'),
            if (docente.dateOfBirth != null)
              _InfoRow(
                  label: 'Fecha de Nacimiento:',
                  value: docente.dateOfBirth.toString().split(' ')[0]),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cerrar',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
