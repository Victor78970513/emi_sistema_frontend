import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/lateral_navigation_bar.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRoutes.docentesPage);
      ref.read(pendingAccountsProvider.notifier).getPendingAccounts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            LateralNavigationBar(),
            Expanded(
              child: widget.child,
            ),
          ],
        ));
  }
}

// class AdminHomePage extends StatelessWidget {
//   final Widget child;
//   const AdminHomePage({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Row(
//           children: [
//             LateralNavigationBar(),
//             Expanded(
//               child: child,
//             ),
//           ],
//         ));
//   }
// }
