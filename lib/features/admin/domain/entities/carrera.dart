import 'asignatura.dart';

class Carrera {
  final String id;
  final String nombre;
  final List<Asignatura> asignaturas;

  Carrera({
    required this.id,
    required this.nombre,
    required this.asignaturas,
  });
}
