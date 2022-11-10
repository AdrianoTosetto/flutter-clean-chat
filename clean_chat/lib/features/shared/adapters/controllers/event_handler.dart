class Event<T> {
  final String name;
  final T? payload;

  Event({required this.name, this.payload});
}

abstract class EventHandler {
  Future<void> handle(Event event);
}
