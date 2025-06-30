import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/lateral_navigation_item.dart';

class LateralNavigationBar extends StatefulWidget {
  const LateralNavigationBar({super.key});

  @override
  State<LateralNavigationBar> createState() => _LateralNavigationBarState();
}

class _LateralNavigationBarState extends State<LateralNavigationBar> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final barWidth = isExpanded ? size.width * 0.2 : size.width * 0.06;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: barWidth,
      child: Column(
        children: [
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
                          Spacer(),
                          LateralNavigatorItem(
                            title: "Cerrar Sesión",
                            icon: Icons.logout,
                            path: AppRoutes.pendingAccountsPage,
                            index: 4,
                          ),
                          SizedBox(height: 20),
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
}
