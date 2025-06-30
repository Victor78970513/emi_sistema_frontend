class User {
  final String token;
  final int userId;
  final String name;
  final String lastName;
  final String email;
  final String rol;
  final bool isActive;
  User({
    required this.token,
    required this.userId,
    required this.name,
    required this.lastName,
    required this.email,
    required this.rol,
    required this.isActive,
  });
}
