import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_header.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_input.dart';
import 'package:go_router/go_router.dart';

class WebLoginPage extends ConsumerStatefulWidget {
  const WebLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends ConsumerState<WebLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authState = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        if (next.user.rol == "admin") {
          context.replace(AppRoutes.docentesPage);
        }
        if (next.user.rol == "docente") {
          context.replace(AppRoutes.personalInfoPage);
        }
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
          height: size.height * 0.6,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
            ),
            child: Column(
              children: [
                AuthHeader(text: "Inicio de Sesion"),
                Spacer(flex: 2),
                AuthInput(
                  hintText: "Correo electronico",
                  suffixIcon: Icons.email_outlined,
                  controller: emailController,
                ),
                AuthInput(
                  hintText: "Contrasena",
                  suffixIcon: Icons.lock_outline_sharp,
                  controller: passwordController,
                ),
                AuthButton(
                  isLoading: authState is AuthLoading,
                  text: "Iniciar Sesion",
                  onPressed: () => ref.read(authProvider.notifier).login(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                  icon: Icons.login_outlined,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tienes una cuenta?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.registerPage),
                      child: Text(
                        "Solicitar Acceso",
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
      ),
    );
  }
}
