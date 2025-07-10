import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/shell_navigator_provider.dart';
import 'package:go_router/go_router.dart';

class LateralNavigatorItem extends ConsumerStatefulWidget {
  final String title;
  final String path;
  final int index;
  final IconData icon;
  final Function()? onTap;

  const LateralNavigatorItem({
    super.key,
    required this.title,
    required this.icon,
    required this.path,
    required this.index,
    this.onTap,
  });

  @override
  ConsumerState<LateralNavigatorItem> createState() =>
      _LateralNavigatorItemState();
}

class _LateralNavigatorItemState extends ConsumerState<LateralNavigatorItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
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
    final shellProvider = ref.watch(shellNavigatorProvider.notifier);
    final currentIndex = ref.watch(shellNavigatorProvider);
    final isSelected = widget.index == currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 8,
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
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            Color(0xff2350ba),
                            Color(0xff2350ba).withValues(alpha: 0.8),
                          ],
                        )
                      : _isHovered
                          ? LinearGradient(
                              colors: [
                                Color(0xff2350ba).withValues(alpha: 0.1),
                                Color(0xff2350ba).withValues(alpha: 0.05),
                              ],
                            )
                          : null,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(
                          color: Color(0xff2350ba),
                          width: 2,
                        )
                      : _isHovered
                          ? Border.all(
                              color: Color(0xff2350ba).withValues(alpha: 0.3),
                              width: 1,
                            )
                          : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Color(0xff2350ba).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : _isHovered
                          ? [
                              BoxShadow(
                                color: Color(0xff2350ba).withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ]
                          : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap ??
                        () {
                          context.go(widget.path);
                          shellProvider.state = widget.index;
                        },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Icono con tamaño fijo
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                widget.icon,
                                color: isSelected
                                    ? Colors.white
                                    : _isHovered
                                        ? Color(0xff2350ba)
                                        : Color(0xff55637f),
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Texto con tamaño controlado
                          SizedBox(
                            height: 32,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : _isHovered
                                          ? Color(0xff2350ba)
                                          : Color(0xff55637f),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Indicador de selección con posición fija
                          if (isSelected)
                            SizedBox(
                              height: 8,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                margin: EdgeInsets.only(top: 2),
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
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
