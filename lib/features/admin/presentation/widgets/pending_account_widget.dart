import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

class PendingAccountWidget extends StatelessWidget {
  final User user;
  const PendingAccountWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff2350ba).withValues(alpha: 0.15),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Color(0xff2350ba),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // Nombre
              Expanded(
                flex: 2,
                child: Text(
                  user.name,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Email
              Expanded(
                flex: 2,
                child: Text(
                  user.lastName,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Teléfono
              Expanded(
                flex: 3,
                child: Text(
                  user.email,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Rol
              Expanded(
                flex: 2,
                child: Text(
                  user.rol,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Estado
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2350ba),
                      padding: EdgeInsets.symmetric(vertical: 24)),
                  onPressed: () {},
                  child: Text(
                    "Aprobar Solicitud",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
