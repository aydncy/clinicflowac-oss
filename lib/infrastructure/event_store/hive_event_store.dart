import 'package:hive_ce/hive.dart';
import '../../domain/events/event_envelope.dart';
import 'event_store.dart';

class HiveEventStore implements EventStore {
  static const String _boxName = 'workflow_events';

  Box<Map<dynamic, dynamic>>? _box;

  Future<void> init() async {
    _box ??= await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  Box<Map<dynamic, dynamic>> get _requireBox {
    final b = _box;
    if (b == null) {
      throw StateError('HiveEventStore not initialized');
    }
    return b;
  }

  Map<String, dynamic> _cast(Map<dynamic, dynamic> m) {
    return m.map((k, v) => MapEntry(k.toString(), v));
  }

  @override
  Future<void> append(WorkflowEvent event) async {
    await _requireBox.put(event.id, event.toJson());
  }

  @override
  Future<List<WorkflowEvent>> loadByEntity({
    required String kind,
    required String id,
  }) async {
    final events = _requireBox.values
        .map((m) => WorkflowEvent.fromJson(_cast(m)))
        .where((e) => e.entity.kind == kind && e.entity.id == id)
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));

    return events;
  }

  @override
  Future<List<WorkflowEvent>> loadAll() async {
    final events = _requireBox.values
        .map((m) => WorkflowEvent.fromJson(_cast(m)))
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));

    return events;
  }
}
