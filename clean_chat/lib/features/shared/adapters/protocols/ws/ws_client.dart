typedef WSListener = void Function(String data);

abstract class WSClient {
  void connect(String uri);
  void listen(WSListener listener);
  void send(String message);
}
