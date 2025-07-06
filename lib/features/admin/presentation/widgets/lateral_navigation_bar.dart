import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/shared/widgets/lateral_navigation_item.dart';
import 'package:go_router/go_router.dart';

class LateralNavigationBar extends ConsumerStatefulWidget {
  const LateralNavigationBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LateralNavigationBarState();
}

class _LateralNavigationBarState extends ConsumerState<LateralNavigationBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        if (isDesktop) {
          // Vista de barra lateral para desktop
          return _buildDesktopNavigation();
        } else {
          // Vista de drawer para mobile
          return _buildMobileNavigation();
        }
      },
    );
  }

  Widget _buildDesktopNavigation() {
    final size = MediaQuery.of(context).size;
    final barWidth = isExpanded ? size.width * 0.2 : size.width * 0.06;

    return Container(
      color: Colors.white,
      width: barWidth,
      child: Column(
        children: [
          // Espacio superior

          // Elementos de navegación
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !isExpanded
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Elementos principales
                          LateralNavigatorItem(
                            index: 0,
                            title: "Docentes",
                            icon: Icons.people,
                            path: AppRoutes.docentesPage,
                          ),
                          LateralNavigatorItem(
                            title: "Solicitud de Registros",
                            icon: Icons.app_registration_outlined,
                            path: AppRoutes.pendingAccountsPage,
                            index: 1,
                          ),
                          LateralNavigatorItem(
                            title: "Asignaturas",
                            icon: Icons.subject_rounded,
                            path: AppRoutes.pendingAccountsPage,
                            index: 2,
                          ),
                          LateralNavigatorItem(
                            title: "Horarios",
                            icon: Icons.insert_chart_outlined,
                            path: AppRoutes.pendingAccountsPage,
                            index: 3,
                          ),

                          // Espacio flexible para empujar el logout hacia abajo
                          Spacer(),

                          // Botón de cerrar sesión
                          LateralNavigatorItem(
                            title: "Cerrar Sesión",
                            icon: Icons.logout,
                            path: AppRoutes.loginPage,
                            onTap: () async {
                              await ref.read(authProvider.notifier).logOut();
                              context.go(AppRoutes.loginPage);
                            },
                            index: 4,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return Container(
      width: 0,
      child: null, // En mobile no mostramos la barra lateral
    );
  }
}

// Widget para el drawer de mobile
class MobileNavigationDrawer extends ConsumerWidget {
  const MobileNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header del drawer
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 20),
              decoration: BoxDecoration(
                color: Color(0xff2350ba).withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xff2350ba),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Panel de Administración",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2350ba),
                    ),
                  ),
                ],
              ),
            ),

            // Elementos de navegación
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context: context,
                    title: "Docentes",
                    icon: Icons.people,
                    path: AppRoutes.docentesPage,
                    index: 0,
                  ),
                  _buildDrawerItem(
                    context: context,
                    title: "Solicitud de Registros",
                    icon: Icons.app_registration_outlined,
                    path: AppRoutes.pendingAccountsPage,
                    index: 1,
                  ),
                  _buildDrawerItem(
                    context: context,
                    title: "Asignaturas",
                    icon: Icons.subject_rounded,
                    path: AppRoutes.pendingAccountsPage,
                    index: 2,
                  ),
                  _buildDrawerItem(
                    context: context,
                    title: "Horarios",
                    icon: Icons.insert_chart_outlined,
                    path: AppRoutes.pendingAccountsPage,
                    index: 3,
                  ),
                ],
              ),
            ),

            // Botón de cerrar sesión
            Container(
              padding: EdgeInsets.all(16),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  await ref.read(authProvider.notifier).logOut();
                  context.go(AppRoutes.loginPage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String path,
    required int index,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xff2350ba)),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Cerrar el drawer
        context.go(path);
      },
    );
  }
}
