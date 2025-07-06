import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/lateral_navigation_bar.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:go_router/go_router.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  final Widget child;
  const AdminHomePage({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  @override
  void initState() {
    print("AdminHomePage - initState iniciado");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("AdminHomePage - PostFrameCallback ejecutado");
      print("AdminHomePage - Navegando a: ${AppRoutes.docentesPage}");
      context.go(AppRoutes.docentesPage);
      print("AdminHomePage - Llamando getPendingAccounts");
      ref.read(pendingAccountsProvider.notifier).getPendingAccounts();
      print("AdminHomePage - Llamando getAllDocentes");
      ref.read(docenteProvider.notifier).getAllDocentes();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("AdminHomePage - build ejecutado");
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;
        print(
            "AdminHomePage - isDesktop: $isDesktop, maxWidth: ${constraints.maxWidth}");

        if (isDesktop) {
          // Vista de desktop con barra lateral
          print("AdminHomePage - Renderizando vista desktop");
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                LateralNavigationBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          );
        } else {
          // Vista de mobile con drawer
          print("AdminHomePage - Renderizando vista mobile");
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Color(0xff2350ba),
                    size: 28,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              title: Text(
                "Panel de Administración",
                style: TextStyle(
                  color: Color(0xff2350ba),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            drawer: MobileNavigationDrawer(),
            body: widget.child,
          );
        }
      },
    );
  }
}
