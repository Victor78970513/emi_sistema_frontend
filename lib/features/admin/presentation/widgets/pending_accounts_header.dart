import 'package:flutter/material.dart';

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 10,
          ),
          // Nombre
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.red,
              child: Text(
                "Nombres",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Email
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.blue,
              child: Text(
                "Apellidos",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Teléfono
          Expanded(
            flex: 3,
            child: Container(
              // color: Colors.pink,
              child: Text(
                "Correo electronico",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Rol
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.green,
              child: Text(
                "Rol de Usuario",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Estado
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.amber,
              child: Text(
                "Acciones",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
