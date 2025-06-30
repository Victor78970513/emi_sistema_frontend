import 'package:flutter/material.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

class PersonalInformationWidget extends StatelessWidget {
  final Docente docente;
  const PersonalInformationWidget({super.key, required this.docente});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PersonalInfoInput(
                    title: "Nombres",
                    text: docente.names,
                    icon: Icons.person,
                  ),
                ),
                Expanded(
                  child: PersonalInfoInput(
                    title: "Apellidos",
                    text: docente.surnames,
                    icon: Icons.person_outline_outlined,
                  ),
                ),
              ],
            ),
            PersonalInfoInput(
              text: docente.email,
              title: "Correo Electronico",
              icon: Icons.email,
            ),
            PersonalInfoInput(
              text: docente.identificationCard,
              title: "Cedula de Identidad",
              icon: Icons.credit_card,
            ),
            PersonalInfoInput(
              text: docente.gender,
              title: "Genero",
              icon: Icons.female_outlined,
            ),
            PersonalInfoInput(
              text: docente.dateOfBirth?.day.toString(),
              title: "Genero",
              icon: Icons.date_range_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceInfoWidget extends StatelessWidget {
  final Docente docente;
  const ExperienceInfoWidget({super.key, required this.docente});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PersonalInfoInput(
                    title: "Experiencia laboral",
                    text: docente.names,
                    icon: Icons.person,
                  ),
                ),
                Expanded(
                  child: PersonalInfoInput(
                    title: "Experiencia en docencia",
                    text: docente.surnames,
                    icon: Icons.person_outline_outlined,
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

class PersonalInfoInput extends StatelessWidget {
  final String? text;
  final String title;
  final IconData icon;
  const PersonalInfoInput(
      {super.key, required this.text, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              hintText: text ?? "Sin informacion",
              hintStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
