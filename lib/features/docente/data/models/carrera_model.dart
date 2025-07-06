class CarreraModel {
  final int id;
  final String nombre;

  CarreraModel({required this.id, required this.nombre});

  factory CarreraModel.fromJson(Map<String, dynamic> json) {
    return CarreraModel(
      id: int.parse(json['id'].toString()),
      nombre: json['nombre'],
    );
  }
}
