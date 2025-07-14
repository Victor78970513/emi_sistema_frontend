class AppRoutes {
  static const String splash = '/';
  static const String loginPage = '/login';
  static const String registerPage = '/register';
  static const String aprovalPendingPage = '/approval-pending-page';

  // AdminShell
  static const String adminShell = '/admin';

  // Admin routes
  static const String docentesPage = '/admin/docentes';
  static const String pendingAccountsPage = '/admin/pending-accounts';
  static const String applicationsPage = '/admin/applications';
  static const String carrerasPage = '/admin/carreras';
  static const String asignaturaDetallePage = '/admin/asignatura/:id';

  // DocenteShell
  static const String docenteShell = '/docente';

  // docente routes
  static const String personalInfoPage = '/docente/personal-info';
  static const String studiesPage = '/docente/studies';
  static const String subjectsCarrersPage = '/docente/subjects-carrers';
}
