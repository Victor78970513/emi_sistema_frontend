import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_lateral_navigation_bar.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_mobile_navigation_drawer.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/carreras_asignadas_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/asignaturas_asignadas_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/asignaturas_disponibles_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/estudios_academicos_form_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Cargar información personal del docente
      ref.read(docenteProvider.notifier).getPersonalInfo();

      // Cargar carreras y asignaturas asignadas
      await _loadCarrerasYAsignaturas();

      // Precargar instituciones y grados académicos para el formulario de estudios
      ref.read(estudiosAcademicosFormProvider.notifier).fetchAllData();

      // Esperar a que se cargue el docente y luego cargar estudios académicos
      await Future.delayed(Duration(milliseconds: 300));
      final docenteState = ref.read(docenteProvider);
      if (docenteState is DocenteSuccessState && docenteState.docente != null) {
        final docenteId = docenteState.docente!.docenteId;
        ref
            .read(estudiosAcademicosProvider.notifier)
            .getEstudiosAcademicos(docenteId: docenteId);
      }
    });
    super.initState();
  }

  Future<void> _loadCarrerasYAsignaturas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      if (token.isNotEmpty) {
        // Cargar carreras asignadas
        ref
            .read(carrerasAsignadasProvider.notifier)
            .getCarrerasAsignadas(token);

        // Cargar asignaturas asignadas
        ref
            .read(asignaturasAsignadasProvider.notifier)
            .getAsignaturasAsignadas(token);

        // Cargar carreras disponibles (para postulación)
        ref.invalidate(carrerasProvider);

        // Cargar asignaturas disponibles (para postulación)
        ref
            .read(asignaturasDisponiblesProvider.notifier)
            .getAsignaturasDisponibles(token);
      }
    } catch (e) {
      print('Error al cargar carreras y asignaturas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        if (isDesktop) {
          // Vista desktop con barra lateral
          return Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                DocenteLateralNavigationBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          );
        } else {
          // Vista mobile/tablet con drawer (sin AppBar)
          return Scaffold(
            backgroundColor: Colors.white,
            drawer: DocenteMobileNavigationDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Color(0xff2350ba),
                size: 24,
              ),
              // toolbarHeight: 0,
            ),
            body: widget.child,
          );
        }
      },
    );
  }
}
