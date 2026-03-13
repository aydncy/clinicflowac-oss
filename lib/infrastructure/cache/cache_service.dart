class CacheEntry<T> {
  final T value;
  final DateTime createdAt;
  final Duration ttl;

  CacheEntry({
    required this.value,
    required this.ttl,
  }) : createdAt = DateTime.now();

  bool get isExpired {
    return DateTime.now().difference(createdAt) > ttl;
  }
}

class CacheService {
  final Map<String, CacheEntry> _cache = {};
  final Duration defaultTTL;

  CacheService({this.defaultTTL = const Duration(hours: 1)});

  void set<T>(String key, T value, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      value: value,
      ttl: ttl ?? defaultTTL,
    );
  }

  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value as T;
  }

  void remove(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  int getSize() => _cache.length;

  Map<String, dynamic> getStats() {
    final expiredCount = _cache.values.where((e) => e.isExpired).length;
    return {
      'total_entries': _cache.length,
      'expired_entries': expiredCount,
      'active_entries': _cache.length - expiredCount,
    };
  }

  void cleanupExpired() {
    _cache.removeWhere((_, entry) => entry.isExpired);
  }
}
