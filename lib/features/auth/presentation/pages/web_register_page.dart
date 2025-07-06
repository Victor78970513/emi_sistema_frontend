import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/routes.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_provider_state.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_button.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/widgets/auth_input.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';

class WebRegisterPage extends ConsumerStatefulWidget {
  const WebRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WebRegisterPageState();
}

class _WebRegisterPageState extends ConsumerState<WebRegisterPage>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int? selectedCarreraId;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reiniciar animación cuando la página se vuelve visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  void _startAnimation() {
    if (!_hasAnimated) {
      _animationController.forward();
      _hasAnimated = true;
    } else {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Iniciar animación en cada build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final carrerasAsync = ref.watch(carrerasProvider);

    ref.listen(authProvider, (previous, next) {
      if (next is AuthRegistered) {
        nameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        setState(() {
          selectedCarreraId = null;
        });
        context.go(AppRoutes.aprovalPendingPage);
      }
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    void _onRegisterPressed() {
      final nombres = nameController.text.trim();
      final apellidos = lastNameController.text.trim();
      final correo = emailController.text.trim();
      final contrasena = passwordController.text.trim();
      if (nombres.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre no puede estar vacío')),
        );
        return;
      }
      if (apellidos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El apellido no puede estar vacío')),
        );
        return;
      }
      if (correo.isEmpty || !correo.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor ingresa un correo válido')),
        );
        return;
      }
      if (contrasena.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña no puede estar vacía')),
        );
        return;
      }
      if (selectedCarreraId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona una carrera')),
        );
        return;
      }
      if (!isLoading) {
        ref.read(authProvider.notifier).register(
              nombres: nombres,
              apellidos: apellidos,
              correo: correo,
              contrasena: contrasena,
              rolId: 2,
              carreraId: selectedCarreraId!,
            );
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
                : constraints.maxWidth * 0.45;
            final containerMaxWidth = 500.0;

            return Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
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
                              Icons.app_registration,
                              size: isMobile ? 48 : 64,
                              color: Color(0xff2350ba),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Solicitar Registro",
                            style: TextStyle(
                              fontSize: isMobile ? 28 : 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff2350ba),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Completa tus datos para solicitar acceso",
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 32),

                          // Campos de entrada
                          AuthInput(
                            hintText: "Nombres",
                            suffixIcon: Icons.person_outline,
                            controller: nameController,
                            isMobile: isMobile,
                          ),
                          AuthInput(
                            hintText: "Apellidos",
                            suffixIcon: Icons.person_outline,
                            controller: lastNameController,
                            isMobile: isMobile,
                          ),
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
                          SizedBox(height: 16),

                          // Dropdown de carreras
                          carrerasAsync.when(
                            data: (carreras) => _ModernDropdown(
                              value: selectedCarreraId,
                              items: carreras
                                  .map((carrera) => DropdownMenuItem<int>(
                                        value: carrera.id,
                                        child: Text(carrera.nombre),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCarreraId = value;
                                });
                              },
                              hintText: 'Selecciona una carrera',
                              isMobile: isMobile,
                            ),
                            loading: () => Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff2350ba),
                                  ),
                                ),
                              ),
                            ),
                            error: (e, _) => Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Error al cargar carreras',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Botón de registro
                          AuthButton(
                            text: "Enviar Solicitud",
                            onPressed: _onRegisterPressed,
                            isLoading: isLoading,
                            icon: Icons.send,
                            isMobile: isMobile,
                            enabled: !isLoading,
                          ),
                          SizedBox(height: 24),

                          // Enlace de login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¿Ya tienes una cuenta?",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => context.go(AppRoutes.loginPage),
                                child: Text(
                                  "Iniciar Sesión",
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget para dropdown moderno
class _ModernDropdown extends StatefulWidget {
  final int? value;
  final List<DropdownMenuItem<int>> items;
  final Function(int?)? onChanged;
  final String hintText;
  final bool isMobile;

  const _ModernDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    required this.isMobile,
  });

  @override
  State<_ModernDropdown> createState() => _ModernDropdownState();
}

class _ModernDropdownState extends State<_ModernDropdown> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isFocused ? Colors.white : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? Color(0xff2350ba) : Colors.grey[300]!,
            width: _isFocused ? 2 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: Color(0xff2350ba).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: DropdownButtonFormField<int>(
          value: widget.value,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: widget.isMobile ? 14 : 16,
            ),
            prefixIcon: Icon(
              Icons.school_outlined,
              color: _isFocused ? Color(0xff2350ba) : Colors.grey[600],
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.isMobile ? 16 : 18,
            ),
          ),
          style: TextStyle(
            fontSize: widget.isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          items: widget.items,
          onChanged: widget.onChanged,
          dropdownColor: Colors.white,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: _isFocused ? Color(0xff2350ba) : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
