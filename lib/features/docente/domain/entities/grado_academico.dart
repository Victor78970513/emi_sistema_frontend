class GradoAcademico {
  final int id;
  final String nombre;
  GradoAcademico({required this.id, required this.nombre});
  factory GradoAcademico.fromJson(Map<String, dynamic> json) => GradoAcademico(
        id: int.parse(json['id'].toString()),
        nombre: json['nombre'],
      );
}
