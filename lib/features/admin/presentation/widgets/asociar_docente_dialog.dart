import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/carreras_provider.dart';
import '../../../../core/preferences/preferences.dart';
import '../../../docente/domain/entities/docente.dart';
import '../../data/models/asociar_docente_request_model.dart';

class AsociarDocenteDialog extends ConsumerStatefulWidget {
  final String asignaturaId;
  final VoidCallback? onSuccess;

  const AsociarDocenteDialog({
    super.key,
    required this.asignaturaId,
    this.onSuccess,
  });

  @override
  ConsumerState<AsociarDocenteDialog> createState() =>
      _AsociarDocenteDialogState();
}

class _AsociarDocenteDialogState extends ConsumerState<AsociarDocenteDialog> {
  bool _isLoading = false;
  Docente? _selectedDocente;

  Future<void> _asociarDocente() async {
    if (_isLoading || _selectedDocente == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = Preferences().userToken;
      if (token.isEmpty) {
        throw Exception('No hay token de autenticación');
      }

      await ref.read(asociarDocenteProvider((
        token: token,
        asignaturaId: widget.asignaturaId,
        request:
            AsociarDocenteRequestModel(docenteId: _selectedDocente!.docenteId),
      )).future);

      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Docente asociado exitosamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      // Llamar callback de éxito
      widget.onSuccess?.call();

      // Cerrar diálogo
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Error al asociar docente: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al asociar docente: ${e.toString()}'),
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
    final docentesAsync =
        ref.watch(docentesDisponiblesProvider(Preferences().userToken));

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.person_add,
            color: Color(0xff2350ba),
            size: 24,
          ),
          SizedBox(width: 12),
          Text(
            'Asociar Docente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff2350ba),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: docentesAsync.when(
          loading: () => Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff2350ba)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando docentes...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar docentes',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          data: (docentes) {
            if (docentes.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay docentes disponibles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Todos los docentes ya están asociados a esta asignatura',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xff2350ba).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xff2350ba).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xff2350ba),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selecciona un docente para asociar a esta asignatura:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff2350ba),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: docentes.length,
                    itemBuilder: (context, index) {
                      final docente = docentes[index] as Docente;
                      final isSelected =
                          _selectedDocente?.docenteId == docente.docenteId;

                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xff2350ba).withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xff2350ba)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Color(0xff2350ba).withValues(alpha: 0.15),
                            child: Text(
                              '${docente.names[0]}${docente.surnames[0]}',
                              style: TextStyle(
                                color: Color(0xff2350ba),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          title: Text(
                            '${docente.names} ${docente.surnames}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Color(0xff2350ba)
                                  : Colors.grey[800],
                            ),
                          ),
                          subtitle: Text(
                            docente.correoElectronico ?? 'Sin correo',
                            style: TextStyle(
                              fontSize: 14,
                              color: isSelected
                                  ? Color(0xff2350ba).withValues(alpha: 0.8)
                                  : Colors.grey[600],
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Color(0xff2350ba),
                                  size: 24,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedDocente = docente;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff2350ba), Color(0xff1a3f8f)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xff2350ba).withValues(alpha: 0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading || _selectedDocente == null
                  ? null
                  : _asociarDocente,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isLoading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    else
                      Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 18,
                      ),
                    SizedBox(width: 8),
                    Text(
                      'Asociar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
