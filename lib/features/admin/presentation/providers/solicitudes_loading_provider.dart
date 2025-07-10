import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para manejar el estado de loading de cada solicitud
final solicitudesLoadingProvider =
    StateNotifierProvider<SolicitudesLoadingNotifier, Map<String, String>>(
        (ref) {
  return SolicitudesLoadingNotifier();
});

class SolicitudesLoadingNotifier extends StateNotifier<Map<String, String>> {
  SolicitudesLoadingNotifier() : super({});

  void setLoading(String solicitudId, String action) {
    state = {...state, solicitudId: action}; // 'approving' o 'rejecting'
  }

  void clearLoading(String solicitudId) {
    final newState = Map<String, String>.from(state);
    newState.remove(solicitudId);
    state = newState;
  }

  bool isApproving(String solicitudId) {
    return state[solicitudId] == 'approving';
  }

  bool isRejecting(String solicitudId) {
    return state[solicitudId] == 'rejecting';
  }

  bool isLoading(String solicitudId) {
    return state[solicitudId] != null;
  }
}
