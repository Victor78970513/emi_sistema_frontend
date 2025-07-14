import 'package:flutter/material.dart';

class AuthInput extends StatefulWidget {
  final String hintText;
  final bool obscure;
  final IconData suffixIcon;
  final TextEditingController controller;
  final bool isMobile;

  const AuthInput({
    super.key,
    required this.hintText,
    this.obscure = false,
    required this.suffixIcon,
    required this.controller,
    this.isMobile = false,
  });

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: widget.isMobile ? 12 : 16,
        horizontal: widget.isMobile ? 20 : 24,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isFocused = hasFocus;
          });
        },
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.obscure,
          style: TextStyle(
            fontSize: widget.isMobile ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: widget.isMobile ? 14 : 16,
            ),
            prefixIcon: Icon(
              widget.suffixIcon,
              color: _isFocused ? Color(0xff2350ba) : Colors.grey[600],
              size: 20,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: widget.isMobile ? 16 : 18,
            ),
          ),
          cursorColor: Color(0xff2350ba),
        ),
      ),
    );
  }
}
