import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/providers/docente_provider_state.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/docente_image.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/personal_info_header.dart';
import 'package:frontend_emi_sistema/features/docente/presentation/widgets/personal_information_widget.dart';

class PersonalInfoPage extends ConsumerWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docenteState = ref.watch(docenteProvider);
    final size = MediaQuery.of(context).size;
    switch (docenteState) {
      case DocenteSuccessState(docente: final docente):
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24).copyWith(bottom: 0),
          child: Container(
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, top: 36, bottom: 36),
                  child: Container(
                    width: size.width * 0.15,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            DocenteImage(docente: docente),
                            SizedBox(height: 20),
                            Text(
                              docente.names,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              docente.surnames,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      // padding: EdgeInsets.symmetric(horizontal: size.width * 0),
                      child: Column(
                        children: [
                          PersonalInfoHeader(
                            text: "Informacion Basica",
                            icon: Icons.accessibility_new_outlined,
                          ),
                          PersonalInformationWidget(docente: docente),
                          SizedBox(height: 20),
                          PersonalInfoHeader(
                            text: "Experiencia Profesional",
                            icon: Icons.work_history,
                          ),
                          ExperienceInfoWidget(docente: docente),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return Text("data");
    }
  }
}
