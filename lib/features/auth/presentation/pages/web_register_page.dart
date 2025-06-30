import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_header.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_input.dart';
import 'package:go_router/go_router.dart';

class WebRegisterPage extends ConsumerStatefulWidget {
  const WebRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WebRegisterPageState();
}

class _WebRegisterPageState extends ConsumerState<WebRegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ref.listen(authProvider, (previous, next) {
      if (next is AuthRegistered) {
        context.go(AppRoutes.aprovalPendingPage);
      }
      if (next is AuthError) {
        print(next.message);
      }
    });
    return Scaffold(
      backgroundColor: Color(0xffEFEFEF),
      body: Center(
        child: Container(
          width: size.width * 0.3,
          height: size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              width: 1,
              color: Colors.black,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 4,
                blurRadius: 10,
              )
            ],
          ),
          child: Column(
            children: [
              AuthHeader(text: "Solicitar Registro"),
              Spacer(flex: 2),
              AuthInput(
                hintText: "Nombres",
                suffixIcon: Icons.person,
                controller: nameController,
              ),
              AuthInput(
                hintText: "Apellidos",
                suffixIcon: Icons.person,
                controller: lastNameController,
              ),
              AuthInput(
                hintText: "Correo electronico",
                suffixIcon: Icons.email_outlined,
                controller: emailController,
              ),
              AuthInput(
                hintText: "Contraseña",
                suffixIcon: Icons.lock_outline_rounded,
                controller: passwordController,
              ),
              //
              AuthButton(
                isLoading: false,
                text: "Enviar Solicitud",
                onPressed: () {
                  // context.go(AppRoutes.aprovalPendingPage);
                  ref.read(authProvider.notifier).register(
                        name: nameController.text,
                        lastName: lastNameController.text,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                },
                icon: Icons.send,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿Ya tienes una cuenta?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      "Iniciar Sesion",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Spacer(flex: 2)
            ],
          ),
        ),
      ),
    );
  }
}
