import 'package:flutter/material.dart';
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
    if (docente.docenteImagePath != null &&
        docente.docenteImagePath!.isNotEmpty) {
      return CircleAvatar(
        radius: size.width * 0.05,
        backgroundImage: NetworkImage(docente.docenteImagePath!),
        backgroundColor: colorScheme.primary.withOpacity(0.1),
      );
    }
    return CircleAvatar(
      radius: size.width * 0.05,
      backgroundColor: colorScheme.primary.withOpacity(0.2),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size.width * 0.04,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
