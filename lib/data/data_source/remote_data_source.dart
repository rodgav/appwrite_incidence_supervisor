import 'dart:typed_data';
import 'package:appwrite/models.dart';
import 'package:appwrite_incidence_supervisor/data/network/app_api.dart';
import 'package:appwrite_incidence_supervisor/data/request/request.dart';
import 'package:appwrite_incidence_supervisor/domain/model/incidence_model.dart';

abstract class RemoteDataSource {
  Future<Session> login(LoginRequest loginRequest);

  Future<Token> forgotPassword(String email);

  Future<dynamic> deleteSession(String sessionId);

  Future<DocumentList> incidences(List<dynamic> queries, int limit, int offset);

  Future<Document> incidence(String incidenceId);

  Future<Document> incidenceCreate(Incidence incidence);

  Future<Document> incidenceUpdate(Incidence incidence);

  Future<Document> user(String userId);

  Future<File> createFile(Uint8List uint8list, String name);

  Future<DocumentList> prioritys(int limit, int offset);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final AppServiceClient _appServiceClient;

  RemoteDataSourceImpl(this._appServiceClient);

  @override
  Future<Session> login(LoginRequest loginRequest) =>
      _appServiceClient.login(loginRequest);

  @override
  Future<Token> forgotPassword(String email) =>
      _appServiceClient.forgotPassword(email);

  @override
  Future<dynamic> deleteSession(String sessionId) =>
      _appServiceClient.deleteSession(sessionId);

  @override
  Future<DocumentList> incidences(
          List<dynamic> queries, int limit, int offset) =>
      _appServiceClient.incidences(queries, limit, offset);

  @override
  Future<Document> incidence(String incidenceId) =>
      _appServiceClient.incidence(incidenceId);

  @override
  Future<Document> incidenceCreate(Incidence incidence) =>
      _appServiceClient.incidenceCreate(incidence);  @override
  Future<Document> incidenceUpdate(Incidence incidence) =>
      _appServiceClient.incidenceUpdate(incidence);

  @override
  Future<Document> user(String userId) => _appServiceClient.user(userId);

  @override
  Future<File> createFile(Uint8List uint8list, String name) =>
      _appServiceClient.createFile(uint8list, name);

  @override
  Future<DocumentList> prioritys(int limit, int offset) =>
      _appServiceClient.prioritys(limit, offset);
}
