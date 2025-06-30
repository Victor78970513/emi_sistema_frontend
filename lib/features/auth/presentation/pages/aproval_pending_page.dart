import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/router/router.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'dart:math' as math;

class AprovalPendingPage extends StatelessWidget {
  const AprovalPendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double maxContainerWidth = 600.0;
    const double maxContainerHeight = 550.0;
    final double containerWidth =
        math.min(size.width * 0.45, maxContainerWidth);
    final double containerHeight =
        math.min(size.height * 0.6, maxContainerHeight);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Container(
          width: containerWidth,
          height: containerHeight,
          padding: const EdgeInsets.all(30.0),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/request_success.jpg",
                width: size.height * 0.15,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 25),
              const Text(
                "¡Solicitud Enviada con Éxito!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                "Tu solicitud de registro ha sido recibida y está pendiente de aprobación por un administrador. Recibirás una notificación por correo electrónico una vez que tu cuenta esté activa.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  AppRouter().clearAndNavigate(context, AppRoutes.loginPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0C1A30),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  "Volver al Inicio de Sesión",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
