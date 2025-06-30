import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final IconData icon;
  final bool isLoading;
  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: GestureDetector(
        onTap: () {
          print("EJECUTANDO");
          onPressed();
        },
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff0C1A30),
            borderRadius: BorderRadius.circular(999),
          ),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
