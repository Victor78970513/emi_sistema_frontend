import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.token,
    required super.userId,
    required super.name,
    required super.lastName,
    required super.email,
    required super.rol,
    required super.estadoId,
    required super.carreraId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Mapear rol_id a nombre de rol
    String getRolName(String rolId) {
      switch (int.tryParse(rolId) ?? 0) {
        case 1:
          return "admin";
        case 2:
          return "docente";
        default:
          return "unknown";
      }
    }

    return UserModel(
      token: json["token"] ?? "",
      userId: json["user"]["id"] ?? "",
      name: json["user"]["nombres"] ?? "",
      lastName: json["user"]["apellidos"] ?? "",
      email: json["user"]["correo"] ?? "",
      rol: getRolName(json["user"]["rol_id"] ?? "0"),
      estadoId: json["user"]["estado_id"] ?? "",
      carreraId: json["user"]["carrera_id"] ?? "",
    );
  }
}
