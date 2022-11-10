import 'dart:developer';

import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_input_port.dart'
    as fetch_users_input_port;
import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_output_port.dart';
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_input_port.dart'
    as send_message_usecase;
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_output_port.dart';
import 'package:clean_chat/features/shared/adapters/presenters/view_model.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

typedef FetchUsersReturnType = Either<DomainError, List<User>>;

class ChatPresenter implements FetchUsersOutputPort, SendMessageOutputPort {
  final ChatViewModel viewModel =
      ChatViewModel(chatViewModelDS: ChatViewModelDS());

  static const String loadingText = 'Loading users...';
  static const String loadError = 'Error while loading users, please retry';

  bool showLoadingText = true;
  bool showLoadedUsers = false;
  bool showLoadError = false;

  void _fetchUsers(FetchUsersReturnType result) {
    if (result.isRight()) {
      viewModel.loadedUsers =
          (result as fetch_users_input_port.ReturnTypeR).value;
    }
  }

  @override
  void consume<T>(T result) {
    if (T == fetch_users_input_port.ReturnType) {
      _fetchUsers(result as FetchUsersReturnType);
    }

    if (T == send_message_usecase.ReturnType) {
      log(result.toString());
    }
  }
}

class ChatViewModel extends ViewModel<ChatViewModelDS> {
  ChatViewModel({required this.chatViewModelDS}) : super(chatViewModelDS);

  final ChatViewModelDS chatViewModelDS;

  List<User> get loadedUsers => chatViewModelDS.loadedUsers;
  bool get hasUsers => chatViewModelDS.hasUsers;

  set loadedUsers(List<User> users) {
    chatViewModelDS.loadedUsers = users;
    chatViewModelDS.hasUsers = true;
    notifyListeners();
  }

  // set hasUsers(bool value) {
  //   chatViewModelDS.hasUsers = value;
  //   notifyListeners();
  // }
}

class ChatViewModelDS {
  bool hasUsers = false;
  List<User> loadedUsers = [];

  ChatViewModelDS();
}
