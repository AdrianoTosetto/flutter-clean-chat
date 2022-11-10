import 'package:clean_chat/features/chat/adapters/controllers/chat_controller.dart';
import 'package:clean_chat/features/chat/adapters/controllers/home_controller.dart';
import 'package:clean_chat/features/chat/adapters/presenters/chat_presenter.dart';
import 'package:clean_chat/features/chat/adapters/presenters/home_presenter.dart';
import 'package:clean_chat/features/chat/adapters/repositories/message_repository_impl.dart';
import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_usecase.dart';
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_usecase.dart';
import 'package:clean_chat/features/chat/external/ui/screens/home_screen.dart';
import 'package:clean_chat/features/shared/domain/repositories/user_repository.dart';
import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';
import 'package:clean_chat/features/shared/external/protocols/ws/ws_client.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void setupChat() {
  // presenters
  locator.registerLazySingleton<ChatPresenter>(() => ChatPresenter());
  locator.registerLazySingleton<HomePresenter>(() => HomePresenter());

  // usecases
  locator.registerLazySingleton<FetchUsersUsecase>(() => FetchUsersUsecase(
      outputPort: locator.get<HomePresenter>(),
      repository: locator.get<UserRepository>()));

  // controllers
  locator.registerLazySingleton<HomeController>(() =>
      HomeController(fetchUsersUsecase: locator.get<FetchUsersUsecase>()));

  // repositories
  locator.registerLazySingleton<MessageRepositoryImpl>(() =>
      MessageRepositoryImpl(
          wsClient: StandartWebSocketClient(),
          uri: 'http://192.168.100.27:4040'));

  locator.registerLazySingleton<SendMessageUsecase>(() => SendMessageUsecase(
      outputPort: locator.get<ChatPresenter>(),
      repository: locator.get<MessageRepositoryImpl>()));

  locator.registerLazySingleton<ChatController>(() => ChatController(
        sendMessageUsecase: locator.get<SendMessageUsecase>(),
        fetchUsersUsecase: locator.get<FetchUsersUsecase>(),
        storage: locator.get<LocalStorage>(),
      ));

  locator.registerLazySingleton<HomeScreen>(() => HomeScreen(
      controller: locator.get<HomeController>(),
      presenter: locator.get<HomePresenter>()));
}
