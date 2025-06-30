import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/admin_home_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/docentes_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/pending_accounts_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/auth_checking_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_login_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_register_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  factory AppRouter() {
    return _instance;
  }
  AppRouter._privateConstructor();

  static final AppRouter _instance = AppRouter._privateConstructor();

  static final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: AppRoutes.loginPage,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authState = ref.watch(authProvider);
        final bool isCheckingAuth =
            authState is AuthInitial || authState is AuthLoading;
        final isOnLogin = state.uri.path == AppRoutes.loginPage;
        final isOnSplash = state.uri.path == AppRoutes.splash;
        try {
          if (isOnSplash && isCheckingAuth) {
            return null;
          }
          if (authState is! AuthSuccess && !isOnLogin) {
            return AppRoutes.loginPage;
          }

          if (authState is AuthSuccess && isOnLogin) {
            return AppRoutes.docentesPage;
          }
        } catch (e, stack) {
          print("ERROR: $e");
          print("STACK: $stack");
        }
        return null;
      },
      routes: [
        // SPLASH
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          builder: (context, state) {
            return AuthCheckingPage();
          },
        ),
        //LOGIN PAGE
        GoRoute(
          path: AppRoutes.loginPage,
          name: AppRoutes.loginPage,
          builder: (context, state) {
            return WebLoginPage();
          },
        ),

        // REGISTER PAGE5
        GoRoute(
          path: AppRoutes.registerPage,
          name: AppRoutes.registerPage,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: WebRegisterPage(),
            );
          },
        ),

        // ADMIN VIEWS
        ShellRoute(
          builder: (context, state, child) {
            return AdminHomePage(child: child);
          },
          routes: [
            //DOCENTES

            GoRoute(
              path: AppRoutes.docentesPage,
              name: AppRoutes.docentesPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: DocentesPage(),
                );
              },
            ),

            //SOLICITUDES DE REGISTRO
            GoRoute(
              path: AppRoutes.pendingAccountsPage,
              name: AppRoutes.pendingAccountsPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: PendingAccountsPage(),
                );
              },
            ),
          ],
        )
      ],
    );
  });

  // static final GoRouter router =
}
