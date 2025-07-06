import 'package:flutter/material.dart';

class UserInfoHeader extends StatelessWidget {
  const UserInfoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        final titleTextStyle = TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff2350ba),
          letterSpacing: 0.5,
        );

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Color(0xff2350ba).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xff2350ba).withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 24 : 16,
            vertical: 16,
          ),
          child: Row(
            children: [
              SizedBox(
                width: isDesktop ? 60 : 50,
                height: 10,
              ),
              // Nombre
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Color(0xff2350ba),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Nombres",
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
              // Email
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Color(0xff2350ba),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Apellidos",
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
              // Teléfono
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Color(0xff2350ba),
                    ),
                    SizedBox(width: 6),
                    Text(
                      isDesktop ? "Correo electronico" : "Correo",
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
              // Rol
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 16,
                      color: Color(0xff2350ba),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Rol de Usuario",
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
              // Estado
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 16,
                      color: Color(0xff2350ba),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Acciones",
                      style: titleTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
