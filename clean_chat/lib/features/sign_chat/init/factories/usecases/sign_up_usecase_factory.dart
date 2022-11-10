import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';
import 'package:clean_chat/features/sign_chat/adapters/presenters/sign_up_presenter.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_app_usecase.dart';
import 'package:clean_chat/features/sign_chat/locator.dart';

SignAppUseCase makeSignUpUsecaseFactory() {
  return SignAppUseCase(
    outputBoundary: locator.get<SignUpPresenter>(),
    repository: locator.get<UserRepository>(),
  );
}
