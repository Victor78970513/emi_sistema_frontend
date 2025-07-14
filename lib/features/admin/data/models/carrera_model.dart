import 'asignatura_model.dart';

class CarreraModel {
  final String id;
  final String nombre;
  final List<AsignaturaModel> asignaturas;

  CarreraModel({
    required this.id,
    required this.nombre,
    required this.asignaturas,
  });

  factory CarreraModel.fromJson(Map<String, dynamic> json) {
    return CarreraModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      asignaturas: (json['asignaturas'] as List<dynamic>?)
              ?.map((asignatura) => AsignaturaModel.fromJson(asignatura))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'asignaturas':
          asignaturas.map((asignatura) => asignatura.toJson()).toList(),
    };
  }
}
