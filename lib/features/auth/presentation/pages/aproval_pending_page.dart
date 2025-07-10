import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/router/router.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'dart:math' as math;

class AprovalPendingPage extends StatelessWidget {
  const AprovalPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final double containerMaxWidth = 600.0;
          final double containerWidth = isMobile
              ? constraints.maxWidth * 0.98
              : math.min(constraints.maxWidth * 0.45, containerMaxWidth);
          final double imageSize = isMobile ? 90 : 140;
          final double titleFontSize = isMobile ? 20 : 26;
          final double textFontSize = isMobile ? 13 : 14;
          final double buttonFontSize = isMobile ? 15 : 18;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: containerWidth,
                padding: EdgeInsets.all(isMobile ? 16 : 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 3,
                      blurRadius: 20,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/request_success.jpg",
                      width: imageSize,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "¡Solicitud Enviada con Éxito!",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Tu solicitud de registro ha sido recibida y está pendiente de aprobación por un administrador. Recibirás una notificación por correo electrónico una vez que tu cuenta esté activa.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: textFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter()
                              .clearAndNavigate(context, AppRoutes.loginPage);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0C1A30),
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 10 : 45,
                            vertical: isMobile ? 14 : 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Volver al Inicio de Sesión",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
