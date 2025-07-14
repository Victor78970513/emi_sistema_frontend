import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/shared/widgets/lateral_navigation_item.dart';
import 'package:frontend_emi_sistema/shared/widgets/drawer_item.dart';
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
    final size = MediaQuery.of(context).size;
    final barWidth = isExpanded ? size.width * 0.2 : size.width * 0.07;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        if (!isDesktop) {
          return Container();
        } else {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xff2350ba).withValues(alpha: 0.02),
                ],
              ),
              border: Border(
                right: BorderSide(
                  color: Color(0xff2350ba).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            width: barWidth,
            child: Column(
              children: [
                // Header de la barra lateral
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 16), // Reducir de 20 a 16
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff2350ba).withValues(alpha: 0.1),
                        Color(0xff2350ba).withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xff2350ba).withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10), // Reducir de 12 a 10
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff2350ba).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 20, // Reducir de 24 a 20
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Admin",
                        style: TextStyle(
                          color: Color(0xff2350ba),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Elementos de navegación
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !isExpanded
                        ? Column(
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
                                title: "Postulaciones",
                                icon: Icons.fact_check,
                                path: AppRoutes.applicationsPage,
                                index: 2,
                              ),
                              LateralNavigatorItem(
                                title: "Carreras",
                                icon: Icons.school,
                                path: AppRoutes.carrerasPage,
                                index: 3,
                              ),
                              // LateralNavigatorItem(
                              //   title: "Horarios",
                              //   icon: Icons.insert_chart_outlined,
                              //   path: AppRoutes.pendingAccountsPage,
                              //   index: 4,
                              // ),

                              // Espacio flexible para empujar el logout hacia abajo
                              Spacer(),

                              // Separador
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4), // Reducir vertical de 8 a 4
                                height: 1,
                                color: Color(0xff2350ba).withValues(alpha: 0.1),
                              ),

                              // Botón de cerrar sesión
                              LateralNavigatorItem(
                                title: "Cerrar Sesión",
                                icon: Icons.logout,
                                path: AppRoutes.loginPage,
                                onTap: () async {
                                  await ref
                                      .read(authProvider.notifier)
                                      .logOut();
                                  // ignore: use_build_context_synchronously
                                  context.go(AppRoutes.loginPage);
                                },
                                index: 4,
                              ),
                              SizedBox(
                                  height:
                                      8), // Reducir de 16 a 8 para evitar overflow
                            ],
                          )
                        : null,
                  ),
                ),
              ],
            ),
          );
        }
      },
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
              width: double.infinity,
              padding: EdgeInsets.only(top: 40, bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff2350ba).withValues(alpha: 0.15),
                    Color(0xff2350ba).withValues(alpha: 0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff2350ba).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xff2350ba),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff2350ba).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Panel de Administración",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2350ba),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Elementos de navegación
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItem(
                    title: "Docentes",
                    icon: Icons.people,
                    path: AppRoutes.docentesPage,
                  ),
                  DrawerItem(
                    title: "Solicitud de Registros",
                    icon: Icons.app_registration_outlined,
                    path: AppRoutes.pendingAccountsPage,
                  ),
                  DrawerItem(
                    title: "Postulaciones",
                    icon: Icons.fact_check,
                    path: AppRoutes.applicationsPage,
                  ),
                  DrawerItem(
                    title: "Carreras",
                    icon: Icons.school,
                    path: AppRoutes.carrerasPage,
                  ),
                  // DrawerItem(
                  //   title: "Horarios",
                  //   icon: Icons.insert_chart_outlined,
                  //   path: AppRoutes.pendingAccountsPage,
                  // ),
                ],
              ),
            ),

            // Botón de cerrar sesión
            Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                title: Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                onTap: () async {
                  await ref.read(authProvider.notifier).logOut();
                  // ignore: use_build_context_synchronously
                  context.go(AppRoutes.loginPage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
