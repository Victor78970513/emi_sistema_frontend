import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/admin_home_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/docentes_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/pending_accounts_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/aproval_pending_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/auth_checking_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_login_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_register_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/docente_home_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/personal_info_page.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/pages/studies_page.dart';
// import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
// import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  factory AppRouter() {
    return _instance;
  }
  AppRouter._privateConstructor();

  static final AppRouter _instance = AppRouter._privateConstructor();

  void clearAndNavigate(BuildContext context, String path) {
    while (context.canPop() == true) {
      context.pop();
    }
    context.pushReplacement(path);
  }

  static final routerProvider = Provider<GoRouter>((ref) {
    return GoRouter(
      initialLocation: AppRoutes.loginPage,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        return null;
        // final authState = ref.watch(authProvider);
        // final isOnLogin = state.uri.path == AppRoutes.loginPage;
        // final isOnRegister = state.uri.path == AppRoutes.registerPage;
        // final isOnPendingApproval =
        //     state.uri.path == AppRoutes.aprovalPendingPage;
        // try {
        //   if (authState is! AuthSuccess) {
        //     if (isOnLogin || isOnRegister || isOnPendingApproval) {
        //       return null;
        //     }
        //     return AppRoutes.loginPage;
        //   }
        //   if (isOnLogin || isOnRegister) {
        //     return AppRoutes.docentesPage;
        //   }
        // } catch (e, stack) {
        //   print("ERROR: $e");
        //   print("STACK: $stack");
        // }
        // return null;
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
          ],
        )
      ],
    );
  });

  // static final GoRouter router =
}
