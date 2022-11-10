import 'package:clean_chat/features/shared/adapters/repositories/user_repository_impl.dart';
import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';
import 'package:clean_chat/features/shared/external/adapters/local_storage_adapter.dart';
import 'package:clean_chat/features/shared/external/protocols/http/clients/http_lib_client.dart';
import 'package:clean_chat/features/shared/external/protocols/ws/ws_client.dart';
import 'package:clean_chat/features/sign_chat/adapters/controllers/sign_up_controller.dart';
import 'package:clean_chat/features/sign_chat/adapters/presenters/sign_up_presenter.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_app_usecase.dart';
import 'package:clean_chat/features/sign_chat/external/ui/screens/sign_up_screen.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void setupSignUp() {
  locator.registerLazySingleton<LocalStorage<Map<String, dynamic>>>(
      () => LocalStorageAdapter());

  locator.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(httpClient: HttpLibClient()));
  locator.registerLazySingleton<LocalStorage>(() => LocalStorageAdapter());
  locator.registerLazySingleton<SignUpPresenter>(() => SignUpPresenter());
  locator.registerLazySingleton<SignAppUseCase>(() => SignAppUseCase(
        outputBoundary: locator.get<SignUpPresenter>(),
        repository: locator.get<UserRepository>(),
      ));

  locator.registerLazySingleton<SignUpController>(() => SignUpController(
      useCase: locator.get<SignAppUseCase>(),
      localStorage: locator.get<LocalStorage<Map<String, dynamic>>>(),
      wsClient: StandartWebSocketClient()));

  locator.registerLazySingleton<SignUpScreen>(() => SignUpScreen(
      controller: locator.get<SignUpController>(),
      presenter: locator.get<SignUpPresenter>()));
}
