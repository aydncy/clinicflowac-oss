import '../../domain/events/event_envelope.dart';
import '../../domain/repositories/event_repository.dart';

class InMemoryEventRepository implements EventRepository {
  final List<WorkflowEvent> _events = [];

  @override
  Future<void> save(WorkflowEvent event) async {
    _events.add(event);
  }

  @override
  Future<WorkflowEvent?> getById(String eventId) async {
    try {
      return _events.firstWhere((e) => e.id == eventId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<WorkflowEvent>> getByAggregateId(String aggregateId) async {
    return _events
        .where((e) => e.entity.id == aggregateId)
        .toList();
  }

  @override
  Future<List<WorkflowEvent>> getAll({int limit = 100, int offset = 0}) async {
    return _events
        .skip(offset)
        .take(limit)
        .toList();
  }

  Future<int> getEventCount() async {
    return _events.length;
  }

  Future<bool> isEmpty() async {
    return _events.isEmpty;
  }

  Future<void> clear() async {
    _events.clear();
  }
}
