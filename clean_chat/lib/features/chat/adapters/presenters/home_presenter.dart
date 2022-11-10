import 'dart:developer';

import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_input_port.dart'
    as fetch_users_usecase;
import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_output_port.dart';
import 'package:clean_chat/features/shared/adapters/presenters/view_model.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';

class HomePresenter implements FetchUsersOutputPort {
  static const String errorOnFetchUsers = 'We could not load users available';
  static const String loadingUsersMessage = 'Loading Users';
  final HomeViewModel viewModel =
      HomeViewModel(chatViewModelDS: HomeViewModelDS());

  @override
  void consume<T>(T value) {
    log('loaded users' + viewModel.loadedUsers.toString());
    if (T == fetch_users_usecase.ReturnType) {
      viewModel.loadedUsers = (value as fetch_users_usecase.ReturnTypeR).value;
    }
  }
}

class HomeViewModel extends ViewModel<HomeViewModelDS> {
  HomeViewModel({required this.chatViewModelDS}) : super(chatViewModelDS);

  final HomeViewModelDS chatViewModelDS;

  List<User> get loadedUsers => chatViewModelDS.loadedUsers;

  set loadedUsers(List<User> users) {
    chatViewModelDS.hasUsers = true;
    chatViewModelDS.loadedUsers = users;
    notifyListeners();
  }
}

class HomeViewModelDS {
  bool hasUsers = false;
  List<User> loadedUsers = [];

  HomeViewModelDS();
}
