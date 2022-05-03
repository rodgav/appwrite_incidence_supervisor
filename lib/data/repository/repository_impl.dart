import 'dart:typed_data';

import 'package:appwrite_incidence_supervisor/data/responses/name_response.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:appwrite_incidence_supervisor/data/data_source/local_data_source.dart';
import 'package:appwrite_incidence_supervisor/data/data_source/remote_data_source.dart';
import 'package:appwrite_incidence_supervisor/data/network/failure.dart';
import 'package:appwrite_incidence_supervisor/data/network/network_info.dart';
import 'package:appwrite_incidence_supervisor/data/request/request.dart';
import 'package:appwrite_incidence_supervisor/data/responses/incidence_response.dart';
import 'package:appwrite_incidence_supervisor/data/responses/user_response.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class RepositoryImpl extends Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo? _networkInfo;

  RepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Session>> login(LoginRequest loginRequest) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final response = await _remoteDataSource.login(loginRequest);
        return Right(response);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, Token>> forgotPassword(String email) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final response = await _remoteDataSource.forgotPassword(email);
        return Right(response);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteSession(String sessionId) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final res = await _remoteDataSource.deleteSession(sessionId);
        return Right(res);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Incidence>>> incidences(
      List<dynamic> queries, int limit, int offset) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final response =
            await _remoteDataSource.incidences(queries, limit, offset);
        final a =
            response.documents.map((e) => incidenceFromJson(e.data)).toList();
        return Right(a);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, Incidence>> incidence(String incidenceId) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final response = await _remoteDataSource.incidence(incidenceId);
        final a = incidenceFromJson(response.data);
        return Right(a);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, Incidence>> incidenceCreate(
      Incidence incidence) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final response = await _remoteDataSource.incidenceCreate(incidence);
        final a = incidenceFromJson(response.data);
        return Right(a);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, UsersModel>> user(String userId) async {
    try {
      final response = _localDataSource.getUser();
      return Right(response);
    } catch (cacheError) {
      if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
        try {
          final response = await _remoteDataSource.user(userId);
          final a = usersFromJson(response.data);
          _localDataSource.saveUser(a);
          return Right(a);
        } on AppwriteException catch (e) {
          return Left(Failure(e.code ?? 0,
              e.message ?? 'Some thing went wrong, try again later'));
        } catch (error) {
          return Left(Failure(0, error.toString()));
        }
      } else {
        return Left(Failure(-7, 'Please check your internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, File>> createFile(
      Uint8List uint8list, String name) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final res = await _remoteDataSource.createFile(uint8list, name);
        return Right(res);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<Name>>> prioritys(int limit, int offset) async {
    if (kIsWeb ? true : (await _networkInfo?.isConnected ?? false)) {
      try {
        final res = await _remoteDataSource.prioritys(limit, offset);
        final a = res.documents.map((e) => nameFromJson(e.data)).toList();
        return Right(a);
      } on AppwriteException catch (e) {
        return Left(Failure(e.code ?? 0,
            e.message ?? 'Some thing went wrong, try again later'));
      } catch (error) {
        return Left(Failure(0, error.toString()));
      }
    } else {
      return Left(Failure(-7, 'Please check your internet connection'));
    }
  }
}
