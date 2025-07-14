import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/docente_asignatura.dart';
import '../providers/carreras_provider.dart';
import '../../../../core/preferences/preferences.dart';

class DesasociarDocenteButton extends ConsumerStatefulWidget {
  final DocenteAsignatura docente;
  final String asignaturaId;
  final VoidCallback? onSuccess;

  const DesasociarDocenteButton({
    super.key,
    required this.docente,
    required this.asignaturaId,
    this.onSuccess,
  });

  @override
  ConsumerState<DesasociarDocenteButton> createState() =>
      _DesasociarDocenteButtonState();
}

class _DesasociarDocenteButtonState
    extends ConsumerState<DesasociarDocenteButton> {
  bool _isLoading = false;

  Future<void> _desasociarDocente() async {
    if (_isLoading) return;

    // Mostrar diálogo de confirmación
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Desasociar Docente'),
        content: Text(
          '¿Estás seguro de que quieres desasociar a ${widget.docente.nombres} ${widget.docente.apellidos} de esta asignatura?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Desasociar'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = Preferences().userToken;
      if (token.isEmpty) {
        throw Exception('No hay token de autenticación');
      }

      await ref.read(desasociarDocenteProvider((
        token: token,
        asignaturaId: widget.asignaturaId,
        docenteId: widget.docente.id,
      )).future);

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Docente desasociado exitosamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Llamar callback de éxito
      widget.onSuccess?.call();
    } catch (e) {
      print('Error al desasociar docente: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al desasociar docente: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red[200]!,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _desasociarDocente,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 12 : 10,
              vertical: isTablet ? 8 : 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  SizedBox(
                    width: isTablet ? 16 : 14,
                    height: isTablet ? 16 : 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.red[600]!),
                    ),
                  )
                else
                  Icon(
                    Icons.person_remove,
                    color: Colors.red[600],
                    size: isTablet ? 18 : 16,
                  ),
                SizedBox(width: isTablet ? 6 : 4),
                Text(
                  'Desasociar',
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
