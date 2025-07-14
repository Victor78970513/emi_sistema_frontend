import 'carrera_model.dart';

class CarrerasResponseModel {
  final List<CarreraModel> carreras;

  CarrerasResponseModel({
    required this.carreras,
  });

  factory CarrerasResponseModel.fromJson(Map<String, dynamic> json) {
    return CarrerasResponseModel(
      carreras: (json['carreras'] as List<dynamic>?)
              ?.map((carrera) => CarreraModel.fromJson(carrera))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'carreras': carreras.map((carrera) => carrera.toJson()).toList(),
    };
  }
}
