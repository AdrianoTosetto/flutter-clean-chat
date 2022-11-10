import 'dart:async';
import 'dart:convert';

import 'package:clean_chat/features/chat/domain/entities/message.dart';
import 'package:clean_chat/features/chat/domain/repositories/message_repository.dart';
import 'package:clean_chat/features/shared/adapters/protocols/ws/ws_client.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';

class MessageRepositoryImpl extends MessageRepository {
  MessageRepositoryImpl({required this.wsClient, required this.uri}) {
    _setUp();
  }

  final WSClient wsClient;
  final String uri;
  bool connected = false;

  void _setUp() {}

  @override
  Stream<Message> listenToMessages(User receiver) {
    wsClient.connect(uri);
    StreamController<Message> streamController = StreamController();

    if (!connected) {
      wsClient.send(json.encode({
        'type': 'user_ack',
        'user_id': receiver.id,
      }));
      connected = true;
    }

    wsClient.listen((data) {
      var jsonMessage = json.decode(data);

      streamController.add(Message(
        sender: jsonMessage['sender'],
        receiver: jsonMessage['receiver'],
        content: jsonMessage['content'],
      ));
    });

    return streamController.stream;
  }

  @override
  Future<Either<DomainError, void>> sendMessage(
      User sender, User receiver, String message) async {
    Map<String, String> payload = {
      'sender': sender.id,
      'receiver': receiver.id,
      'message': message,
    };

    wsClient.send(json.encode(payload));

    return Right<DomainError, void>(null);
  }
}
