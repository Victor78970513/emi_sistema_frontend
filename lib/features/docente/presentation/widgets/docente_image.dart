import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

class DocenteImage extends StatelessWidget {
  final Docente docente;
  const DocenteImage({super.key, required this.docente});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String initials =
        docente.names.isNotEmpty ? docente.names[0].toUpperCase() : 'D';

    // Calcular el radio basado en el tamaño de la pantalla
    double radius;
    if (size.width > 1024) {
      // Desktop
      radius = 70;
    } else if (size.width > 768) {
      // Tablet
      radius = 60;
    } else {
      // Mobile
      radius = 50;
    }

    // Verificar si el docente tiene foto
    if (docente.docenteImagePath != null &&
        docente.docenteImagePath!.isNotEmpty) {
      // final String imageUrl = 'http://localhost:3000/uploads/docentes/${docente.docenteImagePath}';
      final String imageUrl =
          '${Constants.baseUrl}uploads/docentes/${docente.docenteImagePath}';

      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error cargando imagen del docente: $exception');
        },
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primary.withOpacity(0.2),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
