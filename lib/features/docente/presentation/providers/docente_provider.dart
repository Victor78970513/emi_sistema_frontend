import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/data/repositories/docente_repository_impl.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';

final docenteDatasourceProvider = Provider<DocenteRemoteDatasource>((ref) {
  return DocenteRemoteDatasourceImpl();
});

final docenteRepositoryProvider = Provider<DocenteRepositoryImpl>((ref) {
  final datasource = ref.watch(docenteDatasourceProvider);
  return DocenteRepositoryImpl(docenteDatasource: datasource);
});

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

class DocenteNotifier extends StateNotifier<DocenteState> {
  final DocenteRepositoryImpl _repository;

  DocenteNotifier(this._repository) : super(DocenteinitialState());

  Future<void> getPersonalInfo() async {
    state = DocenteLoadingState();
    final result = await _repository.getPersonalInfor();
    result.fold(
      (failure) => state = DocenteErrorState(),
      (docente) => state = DocenteSuccessState(docente: docente),
    );
  }

  Future<void> reloadPersonalInfo() async {
    try {
      print('DocenteProvider - Recargando información personal...');
      final result = await _repository.getPersonalInfor();
      result.fold(
        (failure) {
          print(
              'DocenteProvider - Error al recargar información: ${failure.message}');
          state = DocenteErrorState();
        },
        (docente) {
          print(
              'DocenteProvider - Información personal recargada exitosamente');
          state = DocenteSuccessState(docente: docente);
        },
      );
    } catch (e) {
      print('DocenteProvider - Excepción al recargar información: $e');
      state = DocenteErrorState();
    }
  }

  Future<void> getAllDocentes() async {
    print('DocenteNotifier: Iniciando getAllDocentes...');
    state = DocenteLoadingState();
    final result = await _repository.getAllDocentes();
    result.fold(
      (failure) {
        print('DocenteNotifier: Error al obtener docentes: ${failure.message}');
        state = DocenteErrorState();
      },
      (docentes) {
        print(
            'DocenteNotifier: Docentes obtenidos exitosamente: ${docentes.length} docentes');
        state = DocenteSuccessState(docentes: docentes);
      },
    );
  }

  Future<void> updateDocenteProfile(Map<String, dynamic> profileData) async {
    try {
      print('DocenteProvider - Iniciando actualización de perfil');
      print('DocenteProvider - Datos a enviar: $profileData');

      final result = await _repository.updateDocenteProfile(profileData);
      result.fold(
        (failure) {
          print('DocenteProvider - Error en actualización: ${failure.message}');
          // Cambiar el estado a error para mostrar el mensaje
          state = DocenteErrorState();
        },
        (docente) {
          print('DocenteProvider - Perfil actualizado exitosamente');
          // Recargar la información personal para asegurar datos actualizados
          reloadPersonalInfo();
        },
      );
    } catch (e) {
      print('DocenteProvider - Excepción en updateDocenteProfile: $e');
      // Cambiar el estado a error para mostrar el mensaje
      state = DocenteErrorState();
    }
  }

  Future<void> uploadDocentePhoto(dynamic photoFile) async {
    try {
      print('DocenteProvider - Iniciando subida de foto');

      final result = await _repository.uploadDocentePhoto(photoFile);
      result.fold(
        (failure) {
          print(
              'DocenteProvider - Error en subida de foto: ${failure.message}');
          // Cambiar el estado a error para mostrar el mensaje
          state = DocenteErrorState();
        },
        (docente) {
          print('DocenteProvider - Foto subida exitosamente');
          // Recargar la información personal para asegurar datos actualizados
          reloadPersonalInfo();
        },
      );
    } catch (e) {
      print('DocenteProvider - Excepción en uploadDocentePhoto: $e');
      // Cambiar el estado a error para mostrar el mensaje
      state = DocenteErrorState();
    }
  }
}
