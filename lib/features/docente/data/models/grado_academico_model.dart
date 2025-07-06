class GradoAcademicoModel {
  final int id;
  final String nombre;

  GradoAcademicoModel({required this.id, required this.nombre});

  factory GradoAcademicoModel.fromJson(Map<String, dynamic> json) {
    return GradoAcademicoModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}
