import 'package:flutter/material.dart';

class PersonalInfoHeader extends StatelessWidget {
  final String text;
  final IconData icon;
  const PersonalInfoHeader({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
          SizedBox(width: 20),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
