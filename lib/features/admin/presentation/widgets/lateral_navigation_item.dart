import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/shell_navigator_provider.dart';
import 'package:go_router/go_router.dart';

class LateralNavigatorItem extends ConsumerWidget {
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
  Widget build(BuildContext context, ref) {
    final shellProvider = ref.watch(shellNavigatorProvider.notifier);
    final currentIndex = ref.watch(shellNavigatorProvider);
    final isSelected = index == currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Column(
        children: [
          InkWell(
            onTap: onTap ??
                () {
                  context.go(path);
                  shellProvider.state = index;
                },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff2350ba) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : Color(0xff55637f),
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xff55637f),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
