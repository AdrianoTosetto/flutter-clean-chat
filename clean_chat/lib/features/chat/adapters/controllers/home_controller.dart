import 'package:clean_chat/features/chat/domain/usecases/fetch_users/fetch_users_input_port.dart';
import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';

class HomeController extends EventHandler {
  final FetchUsersInputPort fetchUsersUsecase;

  HomeController({required this.fetchUsersUsecase});

  @override
  Future<void> handle(Event event) async {
    await fetchUsersUsecase();
  }
}
