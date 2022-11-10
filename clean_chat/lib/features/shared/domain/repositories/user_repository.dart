import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<DomainError, User>> create(String name);
  Future<Either<DomainError, List<User>>> fetchUserAll();
  Future<Either<DomainError, User>> fetchUserByName(String name);
  Future<Either<DomainError, User>> fetchUserById(String id);
}
