import 'dart:developer';

import 'package:clean_chat/features/shared/adapters/models/user_model.dart';
import 'package:clean_chat/features/shared/adapters/protocols/http/http.dart';
import 'package:clean_chat/features/shared/adapters/protocols/http/http_client.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_chat/features/shared/adapters/extensions/entities/user.dart';

class UserRepositoryImpl extends UserRepository {
  final HttpClient httpClient;
  final baseUrl = 'http://192.168.100.27:4040';

  UserRepositoryImpl({required this.httpClient});

  @override
  Future<Either<DomainError, User>> create(String name) async {
    HttpResponse response = await httpClient.request(HttpRequest(
      method: 'post',
      uri: '$baseUrl/user',
      body: {
        'name': name,
      },
    ));

    return Right(UserModel.fromJson(response.body));
  }

  @override
  Future<Either<DomainError, User>> fetchAll() async {
    HttpResponse response = await httpClient
        .request(HttpRequest(method: 'get', uri: '$baseUrl/users'));
    // TODO: implement fetchUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<DomainError, User>> fetchUserById(String id) {
    // TODO: implement fetchUserById
    throw UnimplementedError();
  }

  @override
  Future<Either<DomainError, User>> fetchUserByName(String name) async {
    HttpResponse response = await httpClient
        .request(HttpRequest(method: 'get', uri: '$baseUrl/users/name/$name'));

    log(response.body.toString());

    if (response.status == 200) {
      return Right(UserExtension.fromJson(response.body));
    } else {
      return Left(NotFound(reason: 'User not found by name'));
    }
  }

  @override
  Future<Either<DomainError, List<User>>> fetchUserAll() async {
    HttpResponse response = await httpClient
        .request(HttpRequest(method: 'get', uri: '$baseUrl/users'));

    if (response.status == 200) {
      return Right((response.body['users'] as List)
          .map<User>((user) => UserExtension.fromJson(user))
          .toList());
    } else {
      return Left(NotFound(reason: 'User not found by name'));
    }
  }
}
