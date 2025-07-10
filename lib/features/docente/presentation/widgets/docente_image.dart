import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/constants/constants.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

class DocenteImage extends StatelessWidget {
  final Docente docente;
  final double? radius;
  final double? size;
  final bool showBorder;
  final Color? backgroundColor;
  final Color? textColor;

  const DocenteImage({
    super.key,
    required this.docente,
    this.radius,
    this.size,
    this.showBorder = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final String initials =
        docente.names.isNotEmpty ? docente.names[0].toUpperCase() : 'D';

    // Calcular el radio basado en el tamaño de la pantalla o usar el proporcionado
    double finalRadius;
    if (radius != null) {
      finalRadius = radius!;
    } else if (size != null) {
      finalRadius = size! / 2;
    } else {
      final size = MediaQuery.of(context).size;
      if (size.width > 1024) {
        // Desktop
        finalRadius = 70;
      } else if (size.width > 768) {
        // Tablet
        finalRadius = 60;
      } else {
        // Mobile
        finalRadius = 50;
      }
    }

    // Verificar si el docente tiene foto
    if (docente.fotoDocente != null && docente.fotoDocente!.isNotEmpty) {
      final String imageUrl =
          '${Constants.baseUrl}uploads/docentes/${docente.fotoDocente}';

      return CircleAvatar(
        radius: finalRadius,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor:
            backgroundColor ?? colorScheme.primary.withValues(alpha: 0.1),
        onBackgroundImageError: (exception, stackTrace) {
          print('Error cargando imagen del docente: $exception');
        },
        child: showBorder
            ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
              )
            : null,
      );
    }

    return CircleAvatar(
      radius: finalRadius,
      backgroundColor:
          backgroundColor ?? colorScheme.primary.withValues(alpha: 0.2),
      child: showBorder
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: finalRadius * 0.6,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          : Text(
              initials,
              style: TextStyle(
                fontSize: finalRadius * 0.6,
                fontWeight: FontWeight.bold,
                color: textColor ?? colorScheme.onPrimary,
              ),
            ),
    );
  }
}
