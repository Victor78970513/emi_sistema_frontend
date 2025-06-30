import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/admin_home_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/docentes_page.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/pages/pending_accounts_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_login_page.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/pages/web_register_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.loginPage,
  debugLogDiagnostics: true,
  // redirect: (context, state) {
  //   final isAuthenticated = ref.read(isAuthenticatedProvider);
  //   final rolUser = ref.read(authRoleProvider);
  //   if (!isAuthenticated) {
  //     return AppRoutes.loginPage;
  //   }
  //   if (rolUser == null) {
  //     return AppRoutes.loginPage;
  //   }
  //   return null;
  // },
  routes: [
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
