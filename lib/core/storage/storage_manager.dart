import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'storage_keys.dart';

/// Persisted key/value storage backed by [FlutterSecureStorage].
@lazySingleton
class StorageManager {
  StorageManager(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read(StorageKey key) => _storage.read(key: key.name);

  Future<void> write(StorageKey key, String value) =>
      _storage.write(key: key.name, value: value);

  Future<void> delete(StorageKey key) => _storage.delete(key: key.name);

  Future<bool> contains(StorageKey key) =>
      _storage.containsKey(key: key.name);

  Future<void> clearAll() => _storage.deleteAll();
}
