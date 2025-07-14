import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_repository_provider.dart';

// Estado para estudios académicos
abstract class EstudiosAcademicosState {}

final class EstudiosAcademicosInitialState extends EstudiosAcademicosState {}

final class EstudiosAcademicosLoadingState extends EstudiosAcademicosState {}

final class EstudiosAcademicosSuccessState extends EstudiosAcademicosState {
  final List<EstudioAcademicoModel> estudios;

  EstudiosAcademicosSuccessState(this.estudios);
}

final class EstudiosAcademicosErrorState extends EstudiosAcademicosState {}

// Provider para estudios académicos
class EstudiosAcademicosNotifier
    extends StateNotifier<EstudiosAcademicosState> {
  final DocenteRepository _docenteRepository;

  EstudiosAcademicosNotifier(this._docenteRepository)
      : super(EstudiosAcademicosInitialState());

  Future<void> getEstudiosAcademicos({required int docenteId}) async {
    state = EstudiosAcademicosLoadingState();
    final response =
        await _docenteRepository.getEstudiosAcademicos(docenteId: docenteId);
    response.fold(
      (left) {
        state = EstudiosAcademicosErrorState();
      },
      (estudios) {
        state = EstudiosAcademicosSuccessState(estudios);
      },
    );
  }

  void reset() {
    state = EstudiosAcademicosInitialState();
  }
}

final estudiosAcademicosProvider =
    StateNotifierProvider<EstudiosAcademicosNotifier, EstudiosAcademicosState>(
        (ref) {
  final repository = ref.read(docenteRepositoryProvider);
  return EstudiosAcademicosNotifier(repository);
});
