import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:appwrite_incidence_supervisor/data/network/failure.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';
import 'package:appwrite_incidence_supervisor/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

import 'base_usecase.dart';

class IncidenceUseCase
    implements
        BaseUseCase<Incidence, Incidence>,
        IncidenceUseCaseIncidence<String, Incidence>,
        IncidenceUseCaseCreateFile<IncidenceUseCaseFile, File>,
        IncidencesUseCasePrioritys<void, List<Name>>,
        IncidenceUseCaseIncidenceCreate<Incidence, Incidence>,
        IncidenceUseCaseDeleteSession<String, dynamic>,
        IncidenceUseCaseAccount<String, UsersModel> {
  final Repository _repository;

  IncidenceUseCase(this._repository);

  @override
  Future<Either<Failure, Incidence>> execute(Incidence incidence) =>
      _repository.incidenceCreate(incidence);

  @override
  Future<Either<Failure, Incidence>> incidence(String incidenceId) =>
      _repository.incidence(incidenceId);

  @override
  Future<Either<Failure, File>> createFile(IncidenceUseCaseFile input) =>
      _repository.createFile(input.uint8list, input.name);

  @override
  Future<Either<Failure, List<Name>>> prioritys(void input) =>
      _repository.prioritys(25, 0);

  @override
  Future<Either<Failure, Incidence>> incidenceCreate(Incidence incidence) =>
      _repository.incidenceCreate(incidence);

  @override
  Future<Either<Failure, dynamic>> deleteSession(String sessionId) =>
      _repository.deleteSession(sessionId);
  @override
  Future<Either<Failure, UsersModel>> user(String userId) =>
      _repository.user(userId);
}

class IncidenceUseCaseFile {
  Uint8List uint8list;
  String name;

  IncidenceUseCaseFile(this.uint8list, this.name);
}

abstract class IncidenceUseCaseIncidence<In, Out> {
  Future<Either<Failure, Out>> incidence(In input);
}

abstract class IncidenceUseCaseCreateFile<In, Out> {
  Future<Either<Failure, Out>> createFile(In input);
}

abstract class IncidencesUseCasePrioritys<In, Out> {
  Future<Either<Failure, Out>> prioritys(In input);
}

abstract class IncidenceUseCaseIncidenceCreate<In, Out> {
  Future<Either<Failure, Out>> incidenceCreate(In input);
}

abstract class IncidenceUseCaseDeleteSession<In, Out> {
  Future<Either<Failure, Out>> deleteSession(In input);
}
abstract class  IncidenceUseCaseAccount<In, Out> {
  Future<Either<Failure, Out>> user(In input);
}

