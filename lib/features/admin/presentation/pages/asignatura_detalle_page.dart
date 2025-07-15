import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/asignatura_detalle_content.dart';
import '../providers/carreras_provider.dart';
import '../../../../core/preferences/preferences.dart';
import 'package:go_router/go_router.dart';

class AsignaturaDetallePage extends ConsumerStatefulWidget {
  final String asignaturaId;
  const AsignaturaDetallePage({
    super.key,
    required this.asignaturaId,
  });

  @override
  ConsumerState<AsignaturaDetallePage> createState() =>
      _AsignaturaDetallePageState();
}

class _AsignaturaDetallePageState extends ConsumerState<AsignaturaDetallePage> {
  @override
  Widget build(BuildContext context) {
    final token = Preferences().userToken;
    final asignaturaDetalleAsync = ref.watch(asignaturaDetalleProvider((
      token: token,
      asignaturaId: widget.asignaturaId,
    )));

    String? carreraId;
    if (asignaturaDetalleAsync is AsyncData) {
      carreraId = asignaturaDetalleAsync.value?.carrera.id;
    }

    String? anteriorId;
    String? siguienteId;
    if (carreraId != null) {
      anteriorId = ref.watch(anteriorAsignaturaProvider((
        token: token,
        asignaturaId: widget.asignaturaId,
        carreraId: carreraId,
      )));
      siguienteId = ref.watch(siguienteAsignaturaProvider((
        token: token,
        asignaturaId: widget.asignaturaId,
        carreraId: carreraId,
      )));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 2,
          backgroundColor: Colors.white,
          shadowColor: Colors.black.withOpacity(0.06),
          title: Row(
            children: [
              Icon(Icons.menu_book_rounded, color: Color(0xff2350ba), size: 28),
              SizedBox(width: 12),
              Text(
                'Detalles de Asignatura',
                style: TextStyle(
                  color: Color(0xff2350ba),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.2,
                ),
              ),
              Spacer(),
              if (anteriorId != null)
                ElevatedButton.icon(
                  onPressed: () {
                    context.pop();
                    context.push('/admin/asignatura/$anteriorId');
                  },
                  icon:
                      Icon(Icons.arrow_back_rounded, color: Color(0xff2350ba)),
                  label: Text('Anterior',
                      style: TextStyle(color: Color(0xff2350ba))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xff2350ba),
                    elevation: 0,
                    side: BorderSide(color: Color(0xff2350ba)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              if (siguienteId != null) SizedBox(width: 8),
              if (siguienteId != null)
                ElevatedButton.icon(
                  onPressed: () {
                    context.pop();
                    context.push('/admin/asignatura/$siguienteId');
                  },
                  icon: Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  label: Text('Siguiente'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2350ba),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
          centerTitle: false,
          iconTheme: const IconThemeData(color: Color(0xff2350ba)),
        ),
      ),
      body: AsignaturaDetalleContent(
        asignaturaId: widget.asignaturaId,
      ),
    );
  }
}
