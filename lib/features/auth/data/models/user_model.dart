import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.token,
    required super.userId,
    required super.name,
    required super.lastName,
    required super.email,
    required super.rol,
    required super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json["token"],
      userId: json["user"]["id"],
      name: json["user"]["name"],
      lastName: json["user"]["lastName"],
      email: json["user"]["email"],
      rol: json["user"]["rol"],
      isActive: json["user"]["isActive"],
    );
  }
}
