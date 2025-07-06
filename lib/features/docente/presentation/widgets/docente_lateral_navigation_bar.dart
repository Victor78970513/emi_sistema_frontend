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
    final barWidth = isExpanded ? size.width * 0.2 : size.width * 0.06;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: Colors.white,
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
                            title: "Informacion Personal",
                            icon: Icons.people,
                            path: AppRoutes.personalInfoPage,
                          ),
                          LateralNavigatorItem(
                            title: "Estudios",
                            icon: Icons.app_registration_outlined,
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
                            icon: Icons.insert_chart_outlined,
                            path: AppRoutes.studiesPage,
                            index: 3,
                          ),
                          Spacer(),
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
