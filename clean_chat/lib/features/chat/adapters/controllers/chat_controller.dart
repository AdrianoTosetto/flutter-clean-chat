import 'dart:developer';

import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_input_port.dart';
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_input_port.dart';
import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';
import 'package:clean_chat/features/shared/adapters/models/user_model.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';

class FetchUsers extends Event {
  static const String eventName = 'LoadUsers';

  FetchUsers() : super(name: eventName);
}

class ConnectToServer extends Event {
  static const String eventName = 'ConnectToServer';
  ConnectToServer() : super(name: eventName);
}

class SendMessage extends Event<SendMessagePayload> {
  static const String eventName = 'SendMessage';
  SendMessage(SendMessagePayload payload)
      : super(name: eventName, payload: payload);
}

class SendMessagePayload {
  final User receiver;
  final String message;

  SendMessagePayload({required this.receiver, required this.message});
}

class ChatController extends EventHandler {
  final FetchUsersInputPort fetchUsersUsecase;
  final SendMessageInputPort sendMessageUsecase;
  final LocalStorage storage;

  ChatController({
    required this.fetchUsersUsecase,
    required this.sendMessageUsecase,
    required this.storage,
  });

  @override
  Future<void> handle(Event event) async {
    if (event is FetchUsers) {
      await fetchUsersUsecase();
    }

    if (event is SendMessage) {
      SendMessagePayload payload = event.payload!;
      var userJson = await storage.fetch('logged_user');
      print(userJson);
      UserModel user = UserModel.fromJson(userJson);
      await sendMessageUsecase(
        user,
        payload.receiver,
        payload.message,
      );
    }
  }
}
