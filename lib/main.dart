import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/router/router.dart';
import 'package:frontend_emi_sistema/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend_emi_sistema/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasourceImpl()),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: 'Material App',
    );
  }
}
