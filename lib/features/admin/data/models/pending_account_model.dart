import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';

class PendingAccountModel extends PendingAccount {
  PendingAccountModel({
    required super.userId,
    required super.name,
    required super.lastName,
    required super.email,
    required super.rol,
    required super.isActive,
  });

  factory PendingAccountModel.fromJson(Map<String, dynamic> json) {
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

    // Mapear estado_id a isActive
    bool getIsActive(String estadoId) {
      return int.tryParse(estadoId) == 1; // 1 = activo, otros = inactivo
    }

    return PendingAccountModel(
      userId: int.tryParse(json["id"] ?? "0") ?? 0,
      name: json["nombres"] ?? "",
      lastName: json["apellidos"] ?? "",
      email: json["correo"] ?? "",
      rol: getRolName(json["rol_id"] ?? "0"),
      isActive: getIsActive(json["estado_id"] ?? "0"),
    );
  }
}
