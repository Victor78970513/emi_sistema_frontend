import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/docente_model.dart';

abstract class DocenteRemoteDatasource {
  Future<DocenteModel> getPersonalInfor({required int userId});
}

class DocenteRemoteDatasourceImpl implements DocenteRemoteDatasource {
  final dio = Dio();
  @override
  Future<DocenteModel> getPersonalInfor({required int userId}) async {
    try {
      final response = await dio.get(
        "http://localhost:3000/api/docente/personal-info",
        queryParameters: {
          "docenteId": userId,
        },
      );

      final docente = DocenteModel.fromJson(response.data);
      return docente;
    } catch (e) {
      print(e.toString());
      throw ServerException("Error al traer la informacion personal");
    }
  }
}
