import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_provider.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/providers/pending_accounts_state.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/pending_account_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/pending_accounts_header.dart';

class PendingAccountsPage extends ConsumerWidget {
  const PendingAccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendinAccountState = ref.watch(pendingAccountsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 1024;

        switch (pendinAccountState) {
          case PendingAccountsInitialState():
          case PendingAccountsLoadingState():
            return Center(
              child: CircularProgressIndicator(),
            );
          case PendingAccountsSuccessState(
              pendingAccounts: final pendingAccounts
            ):
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Header responsive
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 16,
                      vertical: isDesktop ? 24 : 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xff2350ba).withValues(alpha: 0.1),
                          Color(0xff2350ba).withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xff2350ba).withValues(alpha: 0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 32 : 24,
                      vertical: isDesktop ? 24 : 20,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xff2350ba),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.pending_actions,
                            color: Colors.white,
                            size: isDesktop ? 28 : 24,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Solicitudes Pendientes",
                                style: TextStyle(
                                  color: Color(0xff2350ba),
                                  fontSize: isDesktop ? 24 : 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Gestiona las solicitudes de registro de nuevos usuarios",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isDesktop ? 14 : 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff2350ba),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${pendingAccounts.length} solicitudes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isDesktop ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isDesktop ? 25 : 16),

                  // Contenido responsive
                  if (isDesktop) ...[
                    // Vista de tabla para desktop
                    UserInfoHeader(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(color: Colors.grey),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              pendingAccounts.length,
                              (index) {
                                final pendingAccount = pendingAccounts[index];
                                return PendingAccountWidget(
                                  pendingAccount: pendingAccount,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Vista de tarjetas para mobile
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ...List.generate(
                              pendingAccounts.length,
                              (index) {
                                final pendingAccount = pendingAccounts[index];
                                return _MobilePendingAccountCard(
                                  pendingAccount: pendingAccount,
                                );
                              },
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          default:
            return Center(
              child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(pendingAccountsProvider.notifier)
                        .getPendingAccounts();
                  },
                  child: Text("CARGAR DE NUEVO")),
            );
        }
      },
    );
  }
}

// Widget para mostrar cuentas pendientes en mobile como tarjetas
class _MobilePendingAccountCard extends ConsumerWidget {
  final dynamic pendingAccount;

  const _MobilePendingAccountCard({required this.pendingAccount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con avatar y nombre
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xff2350ba).withValues(alpha: 0.15),
                  child: Text(
                    pendingAccount.name.isNotEmpty
                        ? pendingAccount.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Color(0xff2350ba),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${pendingAccount.name} ${pendingAccount.lastName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        pendingAccount.email,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Información adicional
            _InfoRow(label: "Rol", value: pendingAccount.rol),
            SizedBox(height: 8),

            // Botones de acción
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff2350ba).withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2350ba),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ref
                            .read(pendingAccountsProvider.notifier)
                            .aprovePendingAccount(id: pendingAccount.userId);
                      },
                      child: Text(
                        "Aprobar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Implementar lógica de rechazo
                        print("Rechazar solicitud de: ${pendingAccount.name}");
                      },
                      child: Text(
                        "Rechazar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para mostrar información en mobile
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
