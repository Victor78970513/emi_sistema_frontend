import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  final DocenteRemoteDatasource docenteDatasource;

  DocenteRepositoryImpl({required this.docenteDatasource});

  @override
  Future<Either<Failure, Docente>> getPersonalInfor() async {
    try {
      final response = await docenteDatasource.getPersonalInfor();
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CarreraModel>>> getCarreras() async {
    try {
      final response = await docenteDatasource.getCarreras();
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Docente>>> getAllDocentes() async {
    try {
      final response = await docenteDatasource.getAllDocentes();
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EstudioAcademicoModel>>> getEstudiosAcademicos(
      {required int docenteId}) async {
    try {
      final response =
          await docenteDatasource.getEstudiosAcademicos(docenteId: docenteId);
      return right(response);
    } on DioException {
      return left(NetworkFailure('No se pudo conectar al servidor'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Docente>> updateDocenteProfile(
      Map<String, dynamic> profileData) async {
    try {
      final docenteModel =
          await docenteDatasource.updateDocenteProfile(profileData);
      return Right(docenteModel);
    } on DioException catch (e) {
      print(
          'DocenteRepository - DioException en updateDocenteProfile: ${e.message}');
      print('DocenteRepository - Status code: ${e.response?.statusCode}');
      print('DocenteRepository - Response data: ${e.response?.data}');
      return Left(NetworkFailure('Error de conexión: ${e.message}'));
    } on ServerException catch (e) {
      print(
          'DocenteRepository - ServerException en updateDocenteProfile: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('DocenteRepository - Error inesperado en updateDocenteProfile: $e');
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Docente>> uploadDocentePhoto(dynamic photoFile) async {
    try {
      final docenteModel =
          await docenteDatasource.uploadDocentePhoto(photoFile);
      return Right(docenteModel);
    } on DioException catch (e) {
      print(
          'DocenteRepository - DioException en uploadDocentePhoto: ${e.message}');
      print('DocenteRepository - Status code: ${e.response?.statusCode}');
      print('DocenteRepository - Response data: ${e.response?.data}');
      return Left(NetworkFailure('Error de conexión: ${e.message}'));
    } on ServerException catch (e) {
      print(
          'DocenteRepository - ServerException en uploadDocentePhoto: ${e.message}');
      return Left(ServerFailure(e.message));
    } catch (e) {
      print('DocenteRepository - Error inesperado en uploadDocentePhoto: $e');
      return Left(ServerFailure('Error inesperado: ${e.toString()}'));
    }
  }
}
