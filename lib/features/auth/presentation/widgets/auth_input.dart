import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final IconData suffixIcon;
  final TextEditingController controller;
  const AuthInput({
    super.key,
    required this.hintText,
    this.obscure = false,
    required this.suffixIcon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          // filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Icon(
              suffixIcon,
              color: Colors.grey,
            ),
          ),
        ),
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.grey,
        obscureText: obscure,
      ),
    );
  }
}
