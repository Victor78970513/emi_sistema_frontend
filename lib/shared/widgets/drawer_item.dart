import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String path;
  final VoidCallback? onTap;

  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.path,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xff2350ba).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Color(0xff2350ba),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        onTap: onTap ??
            () {
              Navigator.pop(context); // Cerrar el drawer
              context.go(path);
            },
      ),
    );
  }
}
