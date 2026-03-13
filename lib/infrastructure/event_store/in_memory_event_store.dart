import '../../domain/events/event_envelope.dart';
import 'event_store.dart';

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
    return _events
        .where((e) => e.entity.kind == kind && e.entity.id == id)
        .toList();
  }

  @override
  Future<List<WorkflowEvent>> loadAll() async {
    return List.unmodifiable(_events);
  }
}
