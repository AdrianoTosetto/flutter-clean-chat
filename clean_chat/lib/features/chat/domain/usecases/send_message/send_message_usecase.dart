import 'package:clean_chat/features/chat/domain/repositories/message_repository.dart';
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_input_port.dart';
import 'package:clean_chat/features/chat/domain/usecases/send_message/send_message_output_port.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';

class SendMessageUsecase extends SendMessageInputPort {
  final MessageRepository repository;
  final SendMessageOutputPort outputPort;

  SendMessageUsecase({required this.outputPort, required this.repository});

  @override
  Future<ReturnType> call(User sender, User receiver, String message) async {
    var result = await repository.sendMessage(sender, receiver, message);
    outputPort.consume<ReturnType>(result);
    return result;
  }
}
