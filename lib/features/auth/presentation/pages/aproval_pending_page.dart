import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/router/router.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/shared/widgets/modern_button.dart';
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
          final double containerMaxWidth = 500.0;
          final double containerWidth = isMobile
              ? constraints.maxWidth * 0.98
              : math.min(constraints.maxWidth * 0.40, containerMaxWidth);
          final double iconSize = isMobile ? 70 : 110;
          final double titleFontSize = isMobile ? 22 : 28;
          final double textFontSize = isMobile ? 14 : 16;
          final double chipFontSize = isMobile ? 12 : 14;

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: containerWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header degradado con ícono
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff2350ba),
                            Color(0xff0C1A30),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: isMobile ? 32 : 44),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(isMobile ? 16 : 22),
                            child: Icon(
                              Icons.hourglass_top_rounded,
                              color: Color(0xff2350ba),
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Pendiente de aprobación",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w600,
                                fontSize: chipFontSize,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 18 : 36,
                        vertical: isMobile ? 24 : 32,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "¡Solicitud enviada con éxito!",
                            style: TextStyle(
                              color: Color(0xff0C1A30),
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            "Tu solicitud de registro ha sido recibida y está pendiente de aprobación por un administrador. Normalmente tu cuenta se activará en los próximos 5 a 20 minutos. Si tarda más, puedes intentar iniciar sesión nuevamente más tarde.",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: textFontSize,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ModernButton(
                            text: "Volver al inicio de sesión",
                            backgroundColor: Color(0xff2350ba),
                            onPressed: () {
                              AppRouter().clearAndNavigate(
                                  context, AppRoutes.loginPage);
                            },
                            isDesktop: !isMobile,
                            icon: Icons.login_rounded,
                          ),
                        ],
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
