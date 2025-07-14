class CarreraSimpleModel {
  final String id;
  final String nombre;

  CarreraSimpleModel({
    required this.id,
    required this.nombre,
  });

  factory CarreraSimpleModel.fromJson(Map<String, dynamic> json) {
    return CarreraSimpleModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
