import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _singleton = Preferences._();

  factory Preferences() => _singleton;

  Preferences._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> clear() async => _prefs?.clear();

  String get userToken {
    final token = _prefs?.getString('userToken') ?? "";
    return token;
  }

  set userToken(String value) {
    _prefs?.setString("userToken", value);
  }

  String get userRol => _prefs?.getString("userRol") ?? "";
  set userRol(String value) {
    _prefs?.setString("userRol", value);
  }
}
