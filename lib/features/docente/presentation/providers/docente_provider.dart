import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_repository_provider.dart';

class DocenteNotifier extends StateNotifier<DocenteState> {
  final DocenteRepository _docenteRepository;
  DocenteNotifier(this._docenteRepository) : super(DocenteinitialState());

  Future<void> getPersonalInfo({required int userId}) async {
    state = DocenteLoadingState();
    final response = await _docenteRepository.getPersonalInfor(userId: userId);
    response.fold(
      (left) {
        state = DocenteErrorState();
      },
      (docente) {
        state = DocenteSuccessState(docente: docente);
      },
    );
  }
}

final docenteProvider =
    StateNotifierProvider<DocenteNotifier, DocenteState>((ref) {
  final repository = ref.watch(docenteRepositoryProvider);
  return DocenteNotifier(repository);
});

final carrerasProvider = FutureProvider<List<CarreraModel>>((ref) async {
  final repo = ref.watch(docenteRepositoryProvider);
  final result = await repo.getCarreras();
  return result.fold(
      (failure) => throw failure.message, (carreras) => carreras);
});
