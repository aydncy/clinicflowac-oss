import 'package:hive_ce/hive.dart';

import '../../domain/events/event_envelope.dart';
import 'event_store.dart';

class HiveEventStore implements EventStore {
  static const String _boxName = 'workflow_events';

  Box<Map>? _box;

  Future<void> init() async {
    _box ??= await Hive.openBox<Map>(_boxName);
  }

  Box<Map> get _requireBox {
    final b = _box;
    if (b == null) {
      throw StateError('HiveEventStore not initialized. Call init() first.');
    }
    return b;
  }

  @override
  Future<void> append(WorkflowEvent event) async {
    final box = _requireBox;
    // Key: event.id (idempotent overwrite is ok for MVP)
    await box.put(event.id, event.toJson());
  }

  @override
  Future<List<WorkflowEvent>> loadByEntity({
    required String kind,
    required String id,
  }) async {
    final box = _requireBox;

    final events = box.values
        .map((m) => WorkflowEvent.fromJson(m))
        .where((e) => e.entity.kind == kind && e.entity.id == id)
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));

    return events;
  }

  @override
  Future<List<WorkflowEvent>> all() async {
    final box = _requireBox;

    final events = box.values
        .map((m) => WorkflowEvent.fromJson(m))
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));

    return events;
  }

  Future<void> clear() async {
    final box = _requireBox;
    await box.clear();
  }
}
