class InstitucionModel {
  final int id;
  final String nombre;

  InstitucionModel({required this.id, required this.nombre});

  factory InstitucionModel.fromJson(Map<String, dynamic> json) {
    return InstitucionModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}
