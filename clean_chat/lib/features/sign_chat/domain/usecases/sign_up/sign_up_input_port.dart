import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';

typedef ReturnType = Either<DomainError, User>;
typedef ReturnTypeL = Left<DomainError, User>;
typedef ReturnTypeR = Right<DomainError, User>;

abstract class SignUpInputPort {
  Future<ReturnType> call(String name);
}
