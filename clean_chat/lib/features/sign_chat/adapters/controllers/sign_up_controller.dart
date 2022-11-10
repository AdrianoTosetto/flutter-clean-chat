import 'dart:convert';

import 'package:clean_chat/features/shared/adapters/models/user_model.dart';
import 'package:clean_chat/features/shared/adapters/protocols/ws/ws_client.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_up_input_port.dart';
import 'package:dartz/dartz.dart';

class SignUpEvent extends Event<String> {
  SignUpEvent({required String userName})
      : super(name: 'SignUp', payload: userName);
}

class SignUpController extends EventHandler {
  SignUpController({
    required this.useCase,
    required this.wsClient,
    required this.localStorage,
  });

  final SignUpInputPort useCase;
  final WSClient wsClient;
  final LocalStorage<Map<String, dynamic>> localStorage;

  @override
  Future<void> handle(Event event) async {
    final String eventName = event.name;

    switch (eventName) {
      case 'SignUp':
        String name = event.payload as String;
        var result = await _signUp(name);
        if (result.isRight()) {
          UserModel user = UserModel.fromUser((result as ReturnTypeR).value);
          localStorage.save(
            'logged_user',
            user.toJson(),
          );
        }
        // if (result.isRight()) {
        //   var user = (result as ReturnTypeR).value;
        //   wsClient.send(json.encode({
        //     'type': 'user_ack',
        //     'user_id': user.id,
        //   }));
        // }

        break;
      default:
    }
  }

  Future<Either<DomainError, User>> _signUp(String name) async =>
      await useCase(name);
}
