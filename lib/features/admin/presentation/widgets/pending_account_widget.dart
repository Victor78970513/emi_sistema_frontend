import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';

class PendingAccountWidget extends ConsumerWidget {
  final PendingAccount pendingAccount;
  const PendingAccountWidget({super.key, required this.pendingAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff2350ba).withValues(alpha: 0.15),
                  child: Text(
                    pendingAccount.name.isNotEmpty
                        ? pendingAccount.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Color(0xff2350ba),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              // Nombre
              Expanded(
                flex: 2,
                child: Text(
                  pendingAccount.name,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Email
              Expanded(
                flex: 2,
                child: Text(
                  pendingAccount.lastName,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Teléfono
              Expanded(
                flex: 3,
                child: Text(
                  pendingAccount.email,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Rol
              Expanded(
                flex: 2,
                child: Text(
                  pendingAccount.rol,
                  style: titleTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              // Estado
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2350ba),
                      padding: EdgeInsets.symmetric(vertical: 24)),
                  onPressed: () {
                    ref
                        .read(pendingAccountsProvider.notifier)
                        .aprovePendingAccount(id: pendingAccount.userId);
                  },
                  child: Text(
                    "Aprobar Solicitud",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
