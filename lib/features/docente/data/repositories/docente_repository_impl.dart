import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend_emi_sistema/core/error/failures.dart';
import 'package:frontend_emi_sistema/core/error/exceptions.dart';
import 'package:frontend_emi_sistema/features/docente/data/datasources/docente_datasource.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/carrera_model.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/estudio_academico_model.dart';
import 'package:frontend_emi_sistema/features/docente/domain/entities/docente.dart';
import 'package:frontend_emi_sistema/features/docente/domain/repositories/docente_repository.dart';
import 'package:frontend_emi_sistema/features/docente/data/models/docente_model.dart';
import 'dart:io';

class DocenteRepositoryImpl implements DocenteRepository {
  final DocenteRemoteDatasource docenteDatasource;

  DocenteRepositoryImpl({required this.docenteDatasource});

  @override
  Future<Either<Failure, Docente>> getPersonalInfor() async {
    try {
      final response = await docenteDatasource.getPersonalInfor();
      return right(response);
    } on DioError {
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
    } on DioError {
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
    } on DioError {
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
    } on DioError {
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
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Docente>> uploadDocentePhoto(dynamic photoFile) async {
    try {
      final docenteModel =
          await docenteDatasource.uploadDocentePhoto(photoFile);
      return Right(docenteModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
