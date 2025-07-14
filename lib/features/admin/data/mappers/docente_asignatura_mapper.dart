import '../models/docente_asignatura_model.dart';
import '../../domain/entities/docente_asignatura.dart';

class DocenteAsignaturaMapper {
  static DocenteAsignatura fromModel(DocenteAsignaturaModel model) {
    return DocenteAsignatura(
      id: model.id,
      nombres: model.nombres,
      apellidos: model.apellidos,
      correoElectronico: model.correoElectronico,
      fotoDocente: model.fotoDocente,
    );
  }

  static List<DocenteAsignatura> fromModelList(
      List<DocenteAsignaturaModel> models) {
    return models.map((model) => fromModel(model)).toList();
  }
}
