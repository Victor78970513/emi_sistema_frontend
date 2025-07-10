import 'package:flutter/material.dart';

class AuthCheckingPage extends StatelessWidget {
  const AuthCheckingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Verificando autenticación...'),
          ],
        ),
      ),
    );
  }
}
