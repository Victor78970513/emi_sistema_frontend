import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';

abstract class DocenteState {}

final class DocenteinitialState extends DocenteState {}

final class DocenteLoadingState extends DocenteState {}

final class DocenteSuccessState extends DocenteState {
  final Docente docente;

  DocenteSuccessState({required this.docente});
}

final class DocenteErrorState extends DocenteState {}
