import 'dart:math';

/// Basit ID üretimi (demo için).
/// Prod'da UUID v4 veya ULID tercih et.
class Ids {
  static final _rng = Random.secure();

  static String newId({int bytes = 12}) {
    final b = List<int>.generate(bytes, (_) => _rng.nextInt(256));
    return b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  }
}
