import 'package:appwrite_incidence_supervisor/data/network/failure.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';
import 'package:appwrite_incidence_supervisor/domain/repository/repository.dart';
import 'package:appwrite_incidence_supervisor/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class MainUseCase
    implements
        BaseUseCase<MainUseCaseInput, List<Incidence>>,
        MainUseCaseDeleteSession<String, dynamic>,
        MainUseCaseAccount<String, UsersModel> {
  final Repository _repository;

  MainUseCase(this._repository);

  @override
  Future<Either<Failure, List<Incidence>>> execute(MainUseCaseInput input) =>
      _repository.incidences(input.queries, input.limit, input.offset);

  @override
  Future<Either<Failure, dynamic>> deleteSession(String sessionId) =>
      _repository.deleteSession(sessionId);

  @override
  Future<Either<Failure, UsersModel>> user(String userId) =>
      _repository.user(userId);
}

class MainUseCaseInput {
  List<dynamic> queries;
  int limit, offset;

  MainUseCaseInput(this.queries, this.limit, this.offset);
}

abstract class MainUseCaseDeleteSession<In, Out> {
  Future<Either<Failure, Out>> deleteSession(In input);
}

abstract class MainUseCaseAccount<In, Out> {
  Future<Either<Failure, Out>> user(In input);
}
