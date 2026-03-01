import 'event_store.dart';
import '../../domain/events/event_envelope.dart';

class InMemoryEventStore implements EventStore {
  final List<WorkflowEvent> _events = [];

  @override
  Future<void> append(WorkflowEvent event) async {
    _events.add(event);
  }

  @override
  Future<List<WorkflowEvent>> loadByEntity({
    required String kind,
    required String id,
  }) async {
    final out = _events
        .where((e) => e.entity.kind == kind && e.entity.id == id)
        .toList()
      ..sort((a, b) => a.ts.compareTo(b.ts));
    return out;
  }

  @override
  Future<List<WorkflowEvent>> all() async {
    final out = List<WorkflowEvent>.from(_events)
      ..sort((a, b) => a.ts.compareTo(b.ts));
    return out;
  }
}
