import 'package:injectable/injectable.dart';

/// In-memory cache for session-only data. Cleared when the app is killed.
@lazySingleton
class TemporaryCacheManager {
  final Map<String, Object?> _cache = {};

  T? get<T>(String key) {
    final value = _cache[key];
    return value is T ? value : null;
  }

  void set(String key, Object? value) => _cache[key] = value;

  bool contains(String key) => _cache.containsKey(key);

  void remove(String key) => _cache.remove(key);

  void clear() => _cache.clear();
}
