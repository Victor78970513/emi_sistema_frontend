class AsociarDocenteResponseModel {
  final String message;
  final AsociarDocenteDataModel data;

  AsociarDocenteResponseModel({
    required this.message,
    required this.data,
  });

  factory AsociarDocenteResponseModel.fromJson(Map<String, dynamic> json) {
    return AsociarDocenteResponseModel(
      message: json['message'] ?? '',
      data: AsociarDocenteDataModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

class AsociarDocenteDataModel {
  final String id;
  final String docenteId;
  final String asignaturaId;
  final String creadoEn;
  final String modificadoEn;

  AsociarDocenteDataModel({
    required this.id,
    required this.docenteId,
    required this.asignaturaId,
    required this.creadoEn,
    required this.modificadoEn,
  });

  factory AsociarDocenteDataModel.fromJson(Map<String, dynamic> json) {
    return AsociarDocenteDataModel(
      id: json['id']?.toString() ?? '',
      docenteId: json['docente_id']?.toString() ?? '',
      asignaturaId: json['asignatura_id']?.toString() ?? '',
      creadoEn: json['creado_en'] ?? '',
      modificadoEn: json['modificado_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'docente_id': docenteId,
      'asignatura_id': asignaturaId,
      'creado_en': creadoEn,
      'modificado_en': modificadoEn,
    };
  }
}
