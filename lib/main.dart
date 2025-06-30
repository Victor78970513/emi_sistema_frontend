import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/core/preferences/preferences.dart';
import 'package:frontend_emi_sistema/core/router/router.dart';
import 'package:frontend_emi_sistema/features/admin/data/datasource/pending_accounts_datasource.dart';
import 'package:frontend_emi_sistema/features/admin/data/repositories/pending_accounts_repository_impl.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_repository_provider.dart';
import 'package:frontend_emi_sistema/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend_emi_sistema/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend_emi_sistema/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/data/repositories/docente_repository_impl.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_repository_provider.dart';
import 'package:go_router/go_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Preferences().init();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasourceImpl()),
        ),
        pendingAccountsRepositoryProvider.overrideWithValue(
          PendingAccountsRepositoryImpl(
              pendingAccountsDatasource: PendingAccountsDatasourceImpl()),
        ),
        docenteRepositoryProvider.overrideWithValue(
          DocenteRepositoryImpl(
              docenteDatasource: DocenteRemoteDatasourceImpl()),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerProvider = ref.watch(AppRouter.routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: routerProvider,
      title: 'Material App',
    );
  }
}
