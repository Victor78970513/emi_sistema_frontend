import 'package:flutter/material.dart';
import '../../domain/entities/carrera.dart';

class CarreraWidget extends StatelessWidget {
  final Carrera carrera;
  final VoidCallback? onTap;
  final bool isSelected;

  const CarreraWidget({
    super.key,
    required this.carrera,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('DEBUG: CarreraWidget onTap llamado para: ${carrera.nombre}');
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xff2350ba).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xff2350ba) : Colors.grey[200]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icono de carrera
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school,
                color: Color(0xff2350ba),
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            // Información de la carrera
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    carrera.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Color(0xff2350ba) : Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${carrera.asignaturas.length} asignaturas',
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? Color(0xff2350ba).withValues(alpha: 0.7)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // Flecha
            Icon(
              Icons.chevron_right,
              color: isSelected ? Color(0xff2350ba) : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
