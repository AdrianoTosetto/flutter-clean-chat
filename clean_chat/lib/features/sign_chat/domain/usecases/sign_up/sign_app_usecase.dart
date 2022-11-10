import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_up_input_port.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_up_output_port.dart';
import 'package:dartz/dartz.dart';

class SignAppUseCase implements SignUpInputPort {
  final UserRepository repository;
  final SignUpOutputBondary outputBoundary;

  SignAppUseCase({required this.repository, required this.outputBoundary});

  Future<ReturnType> sign(String name) async {
    if (name.length < 6) {
      return ReturnTypeL(LengthError(reason: 'name length must be at least 8'));
    }

    var userSearch = await repository.fetchUserByName(name);

    if (userSearch.isRight()) {
      return ReturnTypeL(
          NameAlreadyTaken(reason: 'Name is already being used'));
    }

    var result = await repository.create(name);

    return result;
  }

  @override
  Future<ReturnType> call(String name) async {
    var ret = await sign(name);
    outputBoundary.consume(ret);
    return ret;
  }
}
