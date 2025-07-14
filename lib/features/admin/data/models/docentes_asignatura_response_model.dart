import 'asignatura_model.dart';
import 'docente_asignatura_model.dart';

class DocentesAsignaturaResponseModel {
  final AsignaturaModel asignatura;
  final List<DocenteAsignaturaModel> docentes;

  DocentesAsignaturaResponseModel({
    required this.asignatura,
    required this.docentes,
  });

  factory DocentesAsignaturaResponseModel.fromJson(Map<String, dynamic> json) {
    return DocentesAsignaturaResponseModel(
      asignatura: AsignaturaModel.fromJson(json['asignatura'] ?? {}),
      docentes: (json['docentes'] as List<dynamic>?)
              ?.map((docente) => DocenteAsignaturaModel.fromJson(docente))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'asignatura': asignatura.toJson(),
      'docentes': docentes.map((docente) => docente.toJson()).toList(),
    };
  }
}
