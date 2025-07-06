import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/shared/widgets/lateral_navigation_item.dart';
import 'package:go_router/go_router.dart';

class DocenteLateralNavigationBar extends ConsumerStatefulWidget {
  const DocenteLateralNavigationBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DocenteLateralNavigationBarState();
}

class _DocenteLateralNavigationBarState
    extends ConsumerState<DocenteLateralNavigationBar> {
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
                  padding: EdgeInsets.symmetric(vertical: 16),
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
                        padding: EdgeInsets.all(10),
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
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Docente",
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
                        ? Container(
                            child: Column(
                              children: [
                                // Elementos principales
                                LateralNavigatorItem(
                                  index: 0,
                                  title: "Información Personal",
                                  icon: Icons.people,
                                  path: AppRoutes.personalInfoPage,
                                ),
                                LateralNavigatorItem(
                                  title: "Estudios",
                                  icon: Icons.school,
                                  path: AppRoutes.studiesPage,
                                  index: 1,
                                ),
                                LateralNavigatorItem(
                                  title: "Asignaturas",
                                  icon: Icons.subject_rounded,
                                  path: AppRoutes.studiesPage,
                                  index: 2,
                                ),
                                LateralNavigatorItem(
                                  title: "Horarios",
                                  icon: Icons.schedule,
                                  path: AppRoutes.studiesPage,
                                  index: 3,
                                ),

                                // Espacio flexible para empujar el logout hacia abajo
                                Spacer(),

                                // Separador
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  height: 1,
                                  color:
                                      Color(0xff2350ba).withValues(alpha: 0.1),
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
                                    context.go(AppRoutes.loginPage);
                                  },
                                  index: 4,
                                ),
                                SizedBox(height: 8),
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
      },
    );
  }
}
