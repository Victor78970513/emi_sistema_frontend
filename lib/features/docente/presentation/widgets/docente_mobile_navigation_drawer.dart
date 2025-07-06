import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/shared/widgets/drawer_item.dart';
import 'package:go_router/go_router.dart';

// Widget para el drawer de mobile del docente
class DocenteMobileNavigationDrawer extends ConsumerWidget {
  const DocenteMobileNavigationDrawer({super.key});

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
                      Icons.person,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Panel del Docente",
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
                    title: "Información Personal",
                    icon: Icons.people,
                    path: AppRoutes.personalInfoPage,
                  ),
                  DrawerItem(
                    title: "Estudios",
                    icon: Icons.school,
                    path: AppRoutes.studiesPage,
                  ),
                  DrawerItem(
                    title: "Asignaturas",
                    icon: Icons.subject_rounded,
                    path: AppRoutes.studiesPage,
                  ),
                  DrawerItem(
                    title: "Horarios",
                    icon: Icons.schedule,
                    path: AppRoutes.studiesPage,
                  ),
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
