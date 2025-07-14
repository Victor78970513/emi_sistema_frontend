import 'package:flutter/material.dart';

class EmptyCarreraPanel extends StatelessWidget {
  const EmptyCarreraPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.school_outlined,
                size: 60,
                color: Color(0xff2350ba).withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Selecciona una carrera',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Haz clic en una carrera del panel izquierdo\npara ver sus detalles y asignaturas',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
