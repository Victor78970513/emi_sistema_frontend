import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';

class PendingAccountWidget extends ConsumerWidget {
  final PendingAccount pendingAccount;
  const PendingAccountWidget({super.key, required this.pendingAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        final titleTextStyle = TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

        return Container(
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 8 : 6,
            horizontal: isDesktop ? 24 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 16 : 12, horizontal: isDesktop ? 20 : 16),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: isDesktop ? 60 : 50,
                      child: CircleAvatar(
                        radius: isDesktop ? 25 : 20,
                        backgroundColor:
                            Color(0xff2350ba).withValues(alpha: 0.15),
                        child: Text(
                          pendingAccount.name.isNotEmpty
                              ? pendingAccount.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Color(0xff2350ba),
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 16 : 14,
                          ),
                        ),
                      ),
                    ),
                    // Nombre
                    Expanded(
                      flex: 2,
                      child: Text(
                        pendingAccount.name,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Email
                    Expanded(
                      flex: 2,
                      child: Text(
                        pendingAccount.lastName,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Teléfono
                    Expanded(
                      flex: 3,
                      child: Text(
                        pendingAccount.email,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Rol
                    Expanded(
                      flex: 2,
                      child: Text(
                        pendingAccount.rol,
                        style: titleTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Botones de acción
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          // Botón Aprobar
                          Expanded(
                            child: _ModernButton(
                              text: "Aprobar",
                              backgroundColor: Color(0xff2350ba),
                              onPressed: () {
                                ref
                                    .read(pendingAccountsProvider.notifier)
                                    .aprovePendingAccount(
                                        id: pendingAccount.userId);
                              },
                              isDesktop: isDesktop,
                            ),
                          ),
                          SizedBox(width: isDesktop ? 8 : 4),
                          // Botón Rechazar
                          Expanded(
                            child: _ModernButton(
                              text: "Rechazar",
                              backgroundColor: Colors.red[600]!,
                              onPressed: () {
                                // TODO: Implementar lógica de rechazo
                                print(
                                    "Rechazar solicitud de: ${pendingAccount.name}");
                              },
                              isDesktop: isDesktop,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget para botones modernos con efectos
class _ModernButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final bool isDesktop;

  const _ModernButton({
    required this.text,
    required this.backgroundColor,
    required this.onPressed,
    required this.isDesktop,
  });

  @override
  State<_ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<_ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animationController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.backgroundColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.backgroundColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    vertical: widget.isDesktop ? 10 : 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: widget.onPressed,
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isDesktop ? 12 : 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
