import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/data/repositories/docente_repository_impl.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'dart:io';

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

  Future<void> getAllDocentes() async {
    state = DocenteLoadingState();
    final result = await _repository.getAllDocentes();
    result.fold(
      (failure) => state = DocenteErrorState(),
      (docentes) => state = DocenteSuccessState(docentes: docentes),
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
          // No cambiar el estado si hay error, solo log
        },
        (docente) {
          print('DocenteProvider - Perfil actualizado exitosamente');
          // Recargar la información personal después de actualizar
          getPersonalInfo();
        },
      );
    } catch (e) {
      print('DocenteProvider - Excepción en updateDocenteProfile: $e');
      // No cambiar el estado si hay excepción, solo log
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
          // No cambiar el estado si hay error, solo log
        },
        (docente) {
          print('DocenteProvider - Foto subida exitosamente');
          // Recargar la información personal después de subir la foto
          getPersonalInfo();
        },
      );
    } catch (e) {
      print('DocenteProvider - Excepción en uploadDocentePhoto: $e');
      // No cambiar el estado si hay excepción, solo log
    }
  }
}
