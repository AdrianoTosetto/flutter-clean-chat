import 'dart:async';

import 'package:clean_chat/features/chat/domain/entities/message.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  Stream<Message> listenToMessages(User receiver);

  Future<Either<DomainError, void>> sendMessage(
      User sender, User receiver, String message);
}
