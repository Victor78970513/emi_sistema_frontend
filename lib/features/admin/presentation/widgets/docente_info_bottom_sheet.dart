import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/docente_detalle_response_model.dart';
import '../providers/carreras_provider.dart';

class DocenteInfoBottomSheet extends ConsumerWidget {
  final String docenteId;
  final String token;

  const DocenteInfoBottomSheet({
    super.key,
    required this.docenteId,
    required this.token,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docenteDetalleAsync = ref.watch(
      docenteDetalleProvider((token: token, docenteId: docenteId)),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: docenteDetalleAsync.when(
        data: (docente) => _buildContent(context, docente),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar información',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, DocenteDetalleResponseModel docenteResponse) {
    final docente = docenteResponse.data;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return SizedBox(
      height: isTablet ? 550 : 500,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xff2350ba).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff2350ba).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xff2350ba),
                    size: isTablet ? 20 : 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Información del Docente',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff2350ba),
                          fontSize: isTablet ? 18 : 16,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, size: isTablet ? 20 : 18),
                  color: Colors.grey[600],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Barra de arrastre
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Contenido principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar y nombre
                  Row(
                    children: [
                      CircleAvatar(
                        radius: isTablet ? 30 : 25,
                        backgroundColor:
                            const Color(0xff2350ba).withValues(alpha: 0.1),
                        child: Text(
                          (docente.nombres.isNotEmpty
                                  ? docente.nombres[0]
                                  : '') +
                              (docente.apellidos.isNotEmpty
                                  ? docente.apellidos[0]
                                  : ''),
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff2350ba),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${docente.nombres} ${docente.apellidos}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                    fontSize: isTablet ? 18 : 16,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Información en lista simple
                  Expanded(
                    child: ListView(
                      children: [
                        _buildInfoRow('Nombres', docente.nombres, isTablet),
                        _buildInfoRow('Apellidos', docente.apellidos, isTablet),
                        _buildInfoRow('Carnet de Identidad',
                            docente.carnetIdentidad, isTablet),
                        _buildInfoRow('Correo Electrónico',
                            docente.correoElectronico, isTablet),
                        _buildInfoRow('Género', docente.genero, isTablet),
                        _buildInfoRow('Experiencia Profesional',
                            docente.experienciaProfesional, isTablet),
                        _buildInfoRow('Experiencia Académica',
                            docente.experienciaAcademica, isTablet),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value, bool isTablet) {
    final displayValue =
        (value == null || value.isEmpty) ? 'No especificado' : value;
    final isNoEspecificado = displayValue == 'No especificado';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isNoEspecificado
              ? Colors.grey[200]!
              : const Color(0xff2350ba).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: isTablet ? 16 : 14,
            color:
                isNoEspecificado ? Colors.grey[500] : const Color(0xff2350ba),
          ),
          SizedBox(width: isTablet ? 12 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isNoEspecificado ? Colors.grey[500] : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
