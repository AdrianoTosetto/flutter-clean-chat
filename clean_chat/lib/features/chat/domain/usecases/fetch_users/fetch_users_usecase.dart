import 'dart:developer';

import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_input_port.dart'
    as fetch_users_seucase;
import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_output_port.dart';
import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';

class FetchUsersUsecase extends fetch_users_seucase.FetchUsersInputPort {
  final UserRepository repository;
  final FetchUsersOutputPort outputPort;

  FetchUsersUsecase({required this.outputPort, required this.repository});

  @override
  Future<fetch_users_seucase.ReturnType> call() async {
    var result = await repository.fetchUserAll();
    outputPort.consume(result);
    return result;
  }
}
