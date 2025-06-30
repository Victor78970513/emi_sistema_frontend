import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/lateral_navigation_bar.dart';

class AdminHomePage extends StatelessWidget {
  final Widget child;
  const AdminHomePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            LateralNavigationBar(),
            Expanded(
              child: child,
            ),
          ],
        ));
  }
}
