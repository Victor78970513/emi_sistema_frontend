import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';

class AuthCheckingPage extends ConsumerWidget {
  const AuthCheckingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = Preferences();
    final authState = ref.watch(authProvider);

    print(
        "AuthCheckingPage - Token guardado: ${prefs.userToken.isNotEmpty ? 'SÍ' : 'NO'}");
    print("AuthCheckingPage - Token: ${prefs.userToken}");

    // Si no hay token, ir directamente al login
    if (prefs.userToken.isEmpty) {
      print("AuthCheckingPage - No hay token, redirigiendo a login");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.replace(AppRoutes.loginPage);
      });
      return _buildLoadingUI();
    }

    // Escuchar cambios en el estado de autenticación
    ref.listen(authProvider, (previous, next) {
      print("AuthCheckingPage - Listener: $previous -> $next");

      if (next is AuthSuccess) {
        print("AuthCheckingPage - Redirigiendo según rol: ${next.user.rol}");
        if (next.user.rol == "admin") {
          print("AuthCheckingPage - Redirigiendo a docentes");
          context.replace(AppRoutes.docentesPage);
        } else if (next.user.rol == "docente") {
          print("AuthCheckingPage - Redirigiendo a personal info");
          context.replace(AppRoutes.personalInfoPage);
        }
      }
      if (next is AuthError) {
        print("AuthCheckingPage - Error: ${next.message}");
        context.replace(AppRoutes.loginPage);
      }
    });

    // Si ya está autenticado, redirigir inmediatamente
    if (authState is AuthSuccess) {
      print(
          "AuthCheckingPage - Ya autenticado, redirigiendo: ${authState.user.rol}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (authState.user.rol == "admin") {
          context.replace(AppRoutes.docentesPage);
        } else if (authState.user.rol == "docente") {
          context.replace(AppRoutes.personalInfoPage);
        }
      });
    }

    // Verificar autenticación si no se ha hecho
    print("AuthCheckingPage - Estado actual: $authState");

    if (authState is AuthInitial) {
      print("AuthCheckingPage - Llamando checkAuth");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authProvider.notifier).checkAuth(token: prefs.userToken);
      });
    }

    return _buildLoadingUI();
  }

  Widget _buildLoadingUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verificando autenticación...'),
          ],
        ),
      ),
    );
  }
}
