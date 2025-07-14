class AsociarDocenteRequestModel {
  final int docenteId;

  AsociarDocenteRequestModel({
    required this.docenteId,
  });

  Map<String, dynamic> toJson() {
    return {
      'docente_id': docenteId,
    };
  }
}
