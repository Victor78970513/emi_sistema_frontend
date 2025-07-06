import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/docente_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';

abstract class DocenteRemoteDatasource {
  Future<DocenteModel> getPersonalInfor({required int userId});
  Future<List<CarreraModel>> getCarreras();
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

  @override
  Future<List<CarreraModel>> getCarreras() async {
    final response =
        await dio.get('http://localhost:3000/api/docente/carreras');
    final data = response.data as List;
    return data.map((json) => CarreraModel.fromJson(json)).toList();
  }
}
