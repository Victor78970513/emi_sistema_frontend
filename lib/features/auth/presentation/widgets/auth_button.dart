import 'package:flutter/material.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLoading;
  final double? fontSize;
  final bool enabled;
  final bool isMobile;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.isLoading,
    this.fontSize,
    this.enabled = true,
    this.isMobile = false,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
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
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.isMobile ? 16 : 20,
        horizontal: widget.isMobile ? 20 : 24,
      ),
      child: MouseRegion(
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
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff2350ba),
                      Color(0xff2350ba).withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Color(0xff2350ba).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.isLoading || !widget.enabled
                        ? null
                        : widget.onPressed,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: widget.isMobile ? 16 : 18,
                      ),
                      child: Center(
                        child: widget.isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: widget.fontSize ??
                                          (widget.isMobile ? 16 : 18),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    widget.icon,
                                    color: Colors.white,
                                    size: widget.isMobile ? 18 : 20,
                                  ),
                                ],
                              ),
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
