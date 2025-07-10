import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/admin_home_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/docentes_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/pending_accounts_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/applications_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/aproval_pending_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_login_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_register_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/docente_home_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/personal_info_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/studies_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/subjects_carrers_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/splash_page.dart';

class AppRouter {
  factory AppRouter() {
    return _instance;
  }
  AppRouter._privateConstructor();

  static final AppRouter _instance = AppRouter._privateConstructor();

  void clearAndNavigate(BuildContext context, String path) {
    context.go(path);
  }

  static final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        try {
          final authState = ref.read(authProvider);
          final isOnSplash = state.uri.path == AppRoutes.splash;
          final isOnLogin = state.uri.path == AppRoutes.loginPage;
          final isOnRegister = state.uri.path == AppRoutes.registerPage;
          final isOnPendingApproval =
              state.uri.path == AppRoutes.aprovalPendingPage;

          // Si está en splash, no redirigir (el splash decide)
          if (isOnSplash) return null;

          // Si el estado es inicial o está cargando, no redirigir
          if (authState is AuthInitial || authState is AuthLoading) {
            return null;
          }

          // Si no está autenticado, permitir acceso a páginas de auth
          if (authState is! AuthSuccess) {
            if (isOnLogin || isOnRegister || isOnPendingApproval) {
              return null;
            }
            return AppRoutes.loginPage;
          }

          // Si está autenticado, no permitir acceso a páginas de auth
          if (isOnLogin || isOnRegister || isOnPendingApproval) {
            if (authState.user.rol == "admin") {
              return AppRoutes.docentesPage;
            } else if (authState.user.rol == "docente") {
              return AppRoutes.personalInfoPage;
            }
          }
        } catch (e, stack) {
          print("ERROR en router: $e");
          print("STACK: $stack");
          // En caso de error, ir al login
          return AppRoutes.loginPage;
        }
        return null;
      },
      routes: [
        // SPLASH PAGE
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splash,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: SplashPage(),
            );
          },
        ),
        //LOGIN PAGE
        GoRoute(
          path: AppRoutes.loginPage,
          name: AppRoutes.loginPage,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: WebLoginPage(),
            );
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

        //APPROVAL PENDING PAGE
        GoRoute(
          path: AppRoutes.aprovalPendingPage,
          name: AppRoutes.aprovalPendingPage,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: state.pageKey,
              child: AprovalPendingPage(),
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

            //APLICACIONES DE CARRERAS Y ASIGNATURAS
            GoRoute(
              path: AppRoutes.applicationsPage,
              name: AppRoutes.applicationsPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: ApplicationsPage(),
                );
              },
            ),
          ],
        ),

        // DOCENTE VIEWS
        ShellRoute(
          builder: (context, state, child) {
            return DocenteHomePage(child: child);
          },
          routes: [
            // PERSONAL-INFO
            GoRoute(
              path: AppRoutes.personalInfoPage,
              name: AppRoutes.personalInfoPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: PersonalInfoPage(),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.studiesPage,
              name: AppRoutes.studiesPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: StudiesPage(),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.subjectsCarrersPage,
              name: AppRoutes.subjectsCarrersPage,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: SubjectsCarrersPage(),
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
