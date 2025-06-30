import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';

class PendingAccountModel extends PendingAccount {
  PendingAccountModel({
    required super.userId,
    required super.name,
    required super.lastName,
    required super.email,
    required super.rol,
  });

  factory PendingAccountModel.fromJson(Map<String, dynamic> json) {
    return PendingAccountModel(
      userId: json["userId"],
      name: json["name"],
      lastName: json["lastName"],
      email: json["email"],
      rol: json["rol"],
    );
  }
}
