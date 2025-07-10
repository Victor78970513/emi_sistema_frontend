class Institucion {
  final int id;
  final String nombre;
  Institucion({required this.id, required this.nombre});
  factory Institucion.fromJson(Map<String, dynamic> json) => Institucion(
        id: int.parse(json['id'].toString()),
        nombre: json['nombre'],
      );
}
