import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/selected_docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';

class DocentesSideBar extends ConsumerWidget {
  final List<Docente> docentes;
  const DocentesSideBar({super.key, required this.docentes});

  @override
  Widget build(BuildContext context, ref) {
    final selectedIndex = ref.watch(selectedDocenteProvider);
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          right: BorderSide(
            color: Color(0xff2350ba).withValues(alpha: 0.08),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar docente o ID',
                prefixIcon: Icon(Icons.search, color: Color(0xff2350ba)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Color(0xff2350ba).withValues(alpha: 0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Color(0xff2350ba).withValues(alpha: 0.10)),
                ),
              ),
              style: TextStyle(fontSize: 15),
              onChanged: (value) {
                // Aquí puedes implementar búsqueda si lo deseas
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: docentes.length,
              separatorBuilder: (_, __) => SizedBox(height: 2),
              itemBuilder: (context, index) {
                final docente = docentes[index];
                final isSelected = selectedIndex == index;
                return DocenteWidget(isSelected, index, docente: docente);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DocenteWidget extends ConsumerWidget {
  final Docente docente;
  final bool isSelected;
  final int index;
  const DocenteWidget(this.isSelected, this.index,
      {super.key, required this.docente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotifier = ref.read(selectedDocenteProvider.notifier);
    return GestureDetector(
      onTap: () => selectedNotifier.state = index,
      child: Container(
        color: isSelected
            ? Color(0xff2350ba).withValues(alpha: 0.08)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            DocenteImage(
              docente: docente,
              radius: 20,
              backgroundColor: Color(0xff2350ba).withValues(alpha: 0.15),
              textColor: Color(0xff2350ba),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${docente.names} ${docente.surnames}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isSelected ? Color(0xff2350ba) : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'ID: ${docente.docenteId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (docente.carreraNombre != null)
                    Text(
                      docente.carreraNombre!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ),
            Text(
              docente.estadoNombre ?? '',
              style: TextStyle(
                fontSize: 12,
                color: docente.estadoNombre == 'aprobado'
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
