import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _handleAuthFlow();
  }

  void _handleAuthFlow() async {
    final prefs = Preferences();
    final token = prefs.userToken;
    if (token.isEmpty) {
      // No hay token, ir directo al login
      _navigate(AppRoutes.loginPage);
      return;
    }
    // Hay token, disparar checkAuth
    ref.read(authProvider.notifier).checkAuth(token: token);
  }

  void _navigate(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (_navigated) return;
      if (next is AuthSuccess) {
        _navigated = true;
        if (next.user.rol == "admin") {
          _navigate(AppRoutes.docentesPage);
        } else if (next.user.rol == "docente") {
          _navigate(AppRoutes.personalInfoPage);
        } else {
          _navigate(AppRoutes.loginPage);
        }
      } else if (next is AuthError) {
        _navigated = true;
        _navigate(AppRoutes.loginPage);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando...'),
          ],
        ),
      ),
    );
  }
}
