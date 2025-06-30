import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_lateral_navigation_bar.dart';

class DocenteHomePage extends ConsumerStatefulWidget {
  final Widget child;
  const DocenteHomePage({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DocenteHomePageState();
}

class _DocenteHomePageState extends ConsumerState<DocenteHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(docenteProvider.notifier).getPersonalInfo(userId: 33);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          DocenteLateralNavigationBar(),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
