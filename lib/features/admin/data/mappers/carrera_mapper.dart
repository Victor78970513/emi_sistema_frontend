import '../models/carrera_model.dart';
import '../../domain/entities/carrera.dart';
import '../../domain/entities/asignatura.dart';

class CarreraMapper {
  static Carrera fromModel(CarreraModel model) {
    return Carrera(
      id: model.id,
      nombre: model.nombre,
      asignaturas: model.asignaturas.map((asignaturaModel) {
        return Asignatura(
          id: asignaturaModel.id,
          materia: asignaturaModel.materia,
          gestion: asignaturaModel.gestion,
          periodo: asignaturaModel.periodo,
          sem: asignaturaModel.sem,
          semestres: asignaturaModel.semestres,
          cargaHoraria: asignaturaModel.cargaHoraria,
          carreraNombre: asignaturaModel.carreraNombre,
        );
      }).toList(),
    );
  }

  static List<Carrera> fromModelList(List<CarreraModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }
}
