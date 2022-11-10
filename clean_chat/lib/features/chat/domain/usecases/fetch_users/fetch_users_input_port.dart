import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';

typedef ReturnType = Either<DomainError, List<User>>;
typedef ReturnTypeL = Left<DomainError, List<User>>;
typedef ReturnTypeR = Right<DomainError, List<User>>;

abstract class FetchUsersInputPort {
  static const Type CallReturnType = ReturnType;
  Future<ReturnType> call();
}
