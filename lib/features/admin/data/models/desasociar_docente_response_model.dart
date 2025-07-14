class DesasociarDocenteResponseModel {
  final String message;

  DesasociarDocenteResponseModel({
    required this.message,
  });

  factory DesasociarDocenteResponseModel.fromJson(Map<String, dynamic> json) {
    return DesasociarDocenteResponseModel(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
