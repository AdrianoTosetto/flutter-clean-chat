abstract class LocalStorage<T> {
  Future<void> save(String key, T value);
  Future<T> fetch(String key);
}
