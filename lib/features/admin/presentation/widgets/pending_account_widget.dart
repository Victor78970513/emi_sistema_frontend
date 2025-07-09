import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/domain/entities/pending_account.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/reject_dialog.dart';
import 'package:frontend_emi_sistema/shared/widgets/modern_button.dart';

class PendingAccountWidget extends ConsumerWidget {
  final PendingAccount pendingAccount;
  const PendingAccountWidget({super.key, required this.pendingAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        final titleTextStyle = TextStyle(
          fontSize: isDesktop ? 16 : 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

        return Container(
          margin: EdgeInsets.symmetric(
            vertical: isDesktop ? 8 : 6,
            horizontal: isDesktop ? 24 : 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: isDesktop ? 16 : 12, horizontal: isDesktop ? 20 : 16),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: isDesktop ? 60 : 50,
                      child: CircleAvatar(
                        radius: isDesktop ? 25 : 20,
                        backgroundColor:
                            Color(0xff2350ba).withValues(alpha: 0.15),
                        child: Text(
                          pendingAccount.name.isNotEmpty
                              ? pendingAccount.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: Color(0xff2350ba),
                            fontWeight: FontWeight.bold,
                            fontSize: isDesktop ? 16 : 14,
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
                    // Botones de acción
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          // Botón Aprobar
                          Expanded(
                            child: ModernButton(
                              text: "Aprobar",
                              backgroundColor: Color(0xff2350ba),
                              onPressed: () {
                                ref
                                    .read(pendingAccountsProvider.notifier)
                                    .aprovePendingAccount(
                                        id: pendingAccount.userId);
                              },
                              isDesktop: isDesktop,
                            ),
                          ),
                          SizedBox(width: isDesktop ? 8 : 4),
                          // Botón Rechazar
                          Expanded(
                            child: ModernButton(
                              text: "Rechazar",
                              backgroundColor: Colors.red[600]!,
                              onPressed: () {
                                print("Botón Rechazar presionado");
                                showDialog(
                                  context:
                                      Navigator.of(context, rootNavigator: true)
                                          .context,
                                  builder: (dialogContext) => RejectDialog(
                                    userName:
                                        "${pendingAccount.name} ${pendingAccount.lastName}",
                                    onReject: (String reason) async {
                                      await ref
                                          .read(
                                              pendingAccountsProvider.notifier)
                                          .rejectPendingAccount(
                                            id: pendingAccount.userId,
                                            reason: reason,
                                          );
                                    },
                                  ),
                                );
                              },
                              isDesktop: isDesktop,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
