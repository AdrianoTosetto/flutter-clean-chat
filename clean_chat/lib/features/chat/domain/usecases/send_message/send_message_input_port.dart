import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';

typedef ReturnType = Either<DomainError, void>;
typedef ReturnTypeL = Left<DomainError, void>;
typedef ReturnTypeR = Right<DomainError, void>;

abstract class SendMessageInputPort {
  static Type returnType = ReturnType;

  Future<ReturnType> call(User sender, User receiver, String message);
}
