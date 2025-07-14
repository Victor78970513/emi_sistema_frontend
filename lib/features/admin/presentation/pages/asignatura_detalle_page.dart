import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/asignatura_detalle_content.dart';

class AsignaturaDetallePage extends ConsumerWidget {
  final String asignaturaId;

  const AsignaturaDetallePage({
    super.key,
    required this.asignaturaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Detalles de Asignatura'),
        backgroundColor: Color(0xff2350ba),
        elevation: 0,
      ),
      body: AsignaturaDetalleContent(asignaturaId: asignaturaId),
    );
  }
}
