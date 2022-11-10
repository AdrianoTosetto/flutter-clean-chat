import 'package:clean_chat/features/shared/adapters/protocols/ws/ws_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StandartWebSocketClient extends WSClient {
  late final WebSocketChannel webSocketChannel;

  StandartWebSocketClient() {
    connect('ws://192.168.100.27:4040/connect');
  }

  @override
  Future<void> connect(String uri) async {
    webSocketChannel = WebSocketChannel.connect(Uri.parse(uri));
  }

  @override
  void listen(WSListener listener) {
    webSocketChannel.stream.listen((dynamic data) => listener(data as String));
  }

  @override
  void send(String message) {
    webSocketChannel.sink.add(message);
  }
}
