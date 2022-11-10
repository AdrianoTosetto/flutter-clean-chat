import 'package:clean_chat/features/shared/domain/storages/local_storage.dart';

import 'package:localstorage/localstorage.dart' as local_storage_lib;

typedef JsonEncodable = Map<String, dynamic>;

class LocalStorageAdapter extends LocalStorage<JsonEncodable> {
  final adaptee = local_storage_lib.LocalStorage('chat_app');
  @override
  Future<JsonEncodable> fetch(String key) async {
    return adaptee.getItem(key);
  }

  @override
  Future<void> save(String key, JsonEncodable value) async {
    await adaptee.setItem(key, value);
  }
}
