import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';

class AuthCheckingPage extends ConsumerStatefulWidget {
  const AuthCheckingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthCheckingPageState();
}

class _AuthCheckingPageState extends ConsumerState<AuthCheckingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = Preferences();
      ref.read(authProvider.notifier).checkAuth(token: prefs.userToken);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        if (next.user.rol == "admin") {
          context.replace(AppRoutes.docentesPage);
        }
      }
      if (next is AuthError) {
        context.replace(AppRoutes.loginPage);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
