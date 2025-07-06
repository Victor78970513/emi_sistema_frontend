import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/features/auth/domain/repositories/auth_repository.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_repository_provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  AuthNotifier(this._authRepository) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    final prefs = Preferences();
    state = AuthLoading();
    final response =
        await _authRepository.login(email: email, password: password);
    response.fold((left) {
      state = AuthError(left.message);
    }, (user) {
      prefs.userToken = user.token;
      prefs.userRol = user.rol;
      state = AuthSuccess(user);
    });
  }

  Future<void> register({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    required int rolId,
    required int carreraId,
  }) async {
    state = AuthLoading();
    await Future.delayed(Duration(seconds: 2));
    final response = await _authRepository.register(
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      contrasena: contrasena,
      rolId: rolId,
      carreraId: carreraId,
    );
    response.fold(
      (left) {
        state = AuthError(left.message);
      },
      (user) {
        if (user) {
          state = AuthRegistered(user);
        }
      },
    );
  }

  Future<void> logOut() async {
    state = AuthLoading();

    final response = await _authRepository.logOut();
    response.fold(
      (left) {
        state = AuthError(left.message);
      },
      (value) {
        if (value) {
          state = AuthInitial();
        } else {
          state = AuthError("Error al cerrar sesión");
        }
      },
    );
  }

  Future<void> checkAuth({required String token}) async {
    final prefs = Preferences();
    state = AuthLoading();
    final response = await _authRepository.checkAuth(token: token);
    response.fold(
      (left) {
        state = AuthError(left.message);
      },
      (user) {
        prefs.userToken = user.token;
        prefs.userRol = user.rol;
        state = AuthSuccess(user);
      },
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
