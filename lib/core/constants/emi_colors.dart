import 'package:flutter/material.dart';

class EMIColors {
  // Colores oficiales de la EMI
  static const Color emiBlue = Color(0xFF003F8A); // PANTONE P 2755 C

  // Paleta profesional mejorada - Solo azules
  static const Color primaryBlue = Color(0xFF1E3A8A); // Azul más elegante
  static const Color secondaryBlue = Color(0xFF3B82F6); // Azul moderno
  static const Color accentBlue = Color(0xFF60A5FA); // Azul claro elegante
  static const Color darkBlue = Color(0xFF1E40AF); // Azul oscuro
  static const Color lightBlue =
      Color(0xFFDBEAFE); // Azul muy claro para fondos

  // Grises profesionales
  static const Color darkGray = Color(0xFF374151);
  static const Color mediumGray = Color(0xFF6B7280);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color veryLightGray = Color(0xFFF9FAFB);

  // Colores de estado
  static const Color successGreen = Color(0xFF10B981);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Gradientes profesionales - Solo azules
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, secondaryBlue],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [veryLightGray, lightGray],
  );

  // Gradiente mixto profesional
  static const LinearGradient professionalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, accentBlue],
  );
}
