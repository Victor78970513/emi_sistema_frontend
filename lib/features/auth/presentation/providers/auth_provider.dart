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
        print("TOKEN: ${prefs.userToken}");
        state = AuthSuccess(user);
      },
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// final authRoleProvider = Provider<String?>((ref) {
//   final state = ref.watch(authProvider);
//   if (state is AuthSuccess) {
//     return state.user.rol; // puede ser "admin", "user", etc.
//   }
//   return null;
// });

// final isAuthenticatedProvider = Provider<bool>((ref) {
//   final state = ref.watch(authProvider);
//   return state is AuthSuccess;
// });
