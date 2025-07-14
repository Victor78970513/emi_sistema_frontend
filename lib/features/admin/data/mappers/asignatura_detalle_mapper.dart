import '../models/asignatura_detalle_model.dart';
import '../../domain/entities/asignatura_detalle.dart';
import '../../domain/entities/carrera.dart';

class AsignaturaDetalleMapper {
  static AsignaturaDetalle fromModel(AsignaturaDetalleModel model) {
    return AsignaturaDetalle(
      id: model.id,
      materia: model.materia,
      gestion: model.gestion,
      periodo: model.periodo,
      sem: model.sem,
      semestres: model.semestres,
      cargaHoraria: model.cargaHoraria,
      creadoEn: model.creadoEn,
      modificadoEn: model.modificadoEn,
      carrera: Carrera(
        id: model.carrera.id,
        nombre: model.carrera.nombre,
        asignaturas: [], // No necesitamos las asignaturas aquí
      ),
    );
  }
}
