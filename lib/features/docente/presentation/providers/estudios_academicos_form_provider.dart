import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/institucion.dart';
import '../../domain/entities/grado_academico.dart';
import '../../domain/repositories/estudios_academicos_repository.dart';
import '../../data/repositories/estudios_academicos_repository_impl.dart';
import 'package:dio/dio.dart';

// Estados para el formulario de estudios académicos
abstract class EstudiosAcademicosFormState {
  const EstudiosAcademicosFormState();
}

class EstudiosAcademicosFormInitial extends EstudiosAcademicosFormState {
  const EstudiosAcademicosFormInitial();
}

class EstudiosAcademicosFormLoading extends EstudiosAcademicosFormState {
  const EstudiosAcademicosFormLoading();
}

class EstudiosAcademicosFormSuccess extends EstudiosAcademicosFormState {
  const EstudiosAcademicosFormSuccess();
}

class EstudiosAcademicosFormError extends EstudiosAcademicosFormState {
  final String message;
  const EstudiosAcademicosFormError(this.message);
}

// Estado para instituciones y grados
class FormDataState {
  final AsyncValue<List<Institucion>> instituciones;
  final AsyncValue<List<GradoAcademico>> grados;
  final EstudiosAcademicosFormState submitState;

  FormDataState({
    required this.instituciones,
    required this.grados,
    required this.submitState,
  });

  FormDataState copyWith({
    AsyncValue<List<Institucion>>? instituciones,
    AsyncValue<List<GradoAcademico>>? grados,
    EstudiosAcademicosFormState? submitState,
  }) {
    return FormDataState(
      instituciones: instituciones ?? this.instituciones,
      grados: grados ?? this.grados,
      submitState: submitState ?? this.submitState,
    );
  }
}

class EstudiosAcademicosFormNotifier extends StateNotifier<FormDataState> {
  final EstudiosAcademicosRepository _repository;

  EstudiosAcademicosFormNotifier(this._repository)
      : super(FormDataState(
          instituciones: const AsyncValue.loading(),
          grados: const AsyncValue.loading(),
          submitState: const EstudiosAcademicosFormInitial(),
        ));

  Future<void> fetchInstituciones() async {
    state = state.copyWith(instituciones: const AsyncValue.loading());
    try {
      final instituciones = await _repository.getInstituciones();
      state = state.copyWith(instituciones: AsyncValue.data(instituciones));
    } catch (e) {
      state = state.copyWith(
        instituciones: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> fetchGrados() async {
    state = state.copyWith(grados: const AsyncValue.loading());
    try {
      final grados = await _repository.getGrados();
      state = state.copyWith(grados: AsyncValue.data(grados));
    } catch (e) {
      state = state.copyWith(
        grados: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      fetchInstituciones(),
      fetchGrados(),
    ]);
  }

  Future<void> submitEstudioAcademico({
    required String titulo,
    required int institucionId,
    required int gradoId,
    required int anioTitulacion,
    required List<int> pdfBytes,
    required String pdfName,
  }) async {
    state = state.copyWith(submitState: const EstudiosAcademicosFormLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken') ?? '';

      await _repository.createEstudioAcademico(
        titulo: titulo,
        institucionId: institucionId,
        gradoId: gradoId,
        anioTitulacion: anioTitulacion,
        pdfBytes: pdfBytes,
        pdfName: pdfName,
        token: token,
      );

      state =
          state.copyWith(submitState: const EstudiosAcademicosFormSuccess());
    } catch (e) {
      state = state.copyWith(
        submitState: EstudiosAcademicosFormError(e.toString()),
      );
    }
  }

  void resetSubmitState() {
    state = state.copyWith(submitState: const EstudiosAcademicosFormInitial());
  }
}

// Provider
final estudiosAcademicosFormProvider =
    StateNotifierProvider<EstudiosAcademicosFormNotifier, FormDataState>((ref) {
  final dio = Dio();
  final repository = EstudiosAcademicosRepositoryImpl(dio);
  return EstudiosAcademicosFormNotifier(repository);
});
