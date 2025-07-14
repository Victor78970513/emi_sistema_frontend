import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_input.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';

class WebLoginPage extends ConsumerStatefulWidget {
  const WebLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends ConsumerState<WebLoginPage>
    with WidgetsBindingObserver {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Precargar las carreras para que estén disponibles en el registro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carrerasProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;

    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        switch (next.user.rol.toLowerCase()) {
          case "admin":
            context.replace(AppRoutes.docentesPage);
            break;
          case "docente":
            context.replace(AppRoutes.personalInfoPage);
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rol de usuario no válido'),
                backgroundColor: Colors.red,
              ),
            );
            break;
        }
      }
      if (next is AuthError) {
        print("WebLoginPage - Error de autenticación: ${next.message}");
        if (next.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    void onLoginPressed() {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingresa un correo válido')),
        );
        return;
      }
      if (password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña no puede estar vacía')),
        );
        return;
      }
      if (!isLoading) {
        ref.read(authProvider.notifier).login(email: email, password: password);
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff2350ba),
              Color(0xff2350ba).withValues(alpha: 0.8),
              Color(0xff2350ba).withValues(alpha: 0.6),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final containerWidth = isMobile
                ? constraints.maxWidth * 0.95
                : constraints.maxWidth * 0.4;
            final containerMaxWidth = 450.0;

            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: containerWidth > containerMaxWidth
                      ? containerMaxWidth
                      : containerWidth,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 40,
                    vertical: isMobile ? 32 : 48,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: Offset(0, 20),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo y título
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xff2350ba).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.school,
                          size: isMobile ? 48 : 64,
                          color: Color(0xff2350ba),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Bienvenido",
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2350ba),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Inicia sesión en tu cuenta",
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 32),

                      // Campos de entrada
                      AuthInput(
                        hintText: "Correo electrónico",
                        suffixIcon: Icons.email_outlined,
                        controller: emailController,
                        isMobile: isMobile,
                      ),
                      AuthInput(
                        hintText: "Contraseña",
                        suffixIcon: Icons.lock_outline,
                        controller: passwordController,
                        obscure: true,
                        isMobile: isMobile,
                      ),
                      SizedBox(height: 24),

                      // Botón de login
                      AuthButton(
                        text: "Iniciar Sesión",
                        onPressed: onLoginPressed,
                        isLoading: isLoading,
                        icon: Icons.login_outlined,
                        isMobile: isMobile,
                        enabled: !isLoading,
                      ),
                      SizedBox(height: 24),

                      // Enlace de registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "¿No tienes una cuenta?",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isMobile ? 14 : 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.registerPage),
                            child: Text(
                              "Solicitar Acceso",
                              style: TextStyle(
                                color: Color(0xff2350ba),
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
