import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/panel_info_row.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

void showDetailsPanelBottomSheet(BuildContext context, Docente docente) {
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
                                      color: docente.estadoNombre == 'aprobado'
                                          ? Colors.green
                                          : Colors.orange,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    docente.estadoNombre ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
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
                          PanelInfoRow(label: 'Nombres', value: docente.names),
                          PanelInfoRow(
                              label: 'Apellidos', value: docente.surnames),
                          PanelInfoRow(
                              label: 'ID Docente',
                              value: docente.docenteId.toString()),
                          if (docente.carreraNombre != null)
                            PanelInfoRow(
                                label: 'Carrera',
                                value: docente.carreraNombre!),
                          PanelInfoRow(
                              label: 'Estado',
                              value: docente.estadoNombre ?? 'No especificado'),
                        ],
                      ),
                    ),
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
                                    padding: EdgeInsets.symmetric(vertical: 12),
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
                                    side: BorderSide(color: Color(0xff2350ba)),
                                    padding: EdgeInsets.symmetric(vertical: 12),
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
