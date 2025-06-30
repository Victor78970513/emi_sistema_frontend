import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/pending_account_widget.dart';
import 'package:frontend_emi_sistema/features/admin/presentation/widgets/pending_accounts_header.dart';
import 'package:frontend_emi_sistema/features/auth/domain/entities/user.dart';

class PendingAccountsPage extends StatelessWidget {
  const PendingAccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Container(
              padding: EdgeInsets.only(left: 50),
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Solicitudes",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
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
                    2,
                    (index) {
                      return PendingAccountWidget(
                        user: User(
                          token: "token",
                          userId: 1,
                          name: "Victor Yerson",
                          lastName: "Choque Mamani",
                          email: "yer29.chok@gmail.com",
                          rol: "docente",
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
