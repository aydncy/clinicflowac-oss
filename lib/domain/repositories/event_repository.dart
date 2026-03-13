import '../events/event_envelope.dart';

abstract class EventRepository {
  Future<void> save(WorkflowEvent event);
  Future<WorkflowEvent?> getById(String eventId);
  Future<List<WorkflowEvent>> getByAggregateId(String aggregateId);
  Future<List<WorkflowEvent>> getAll({int limit = 100, int offset = 0});
}
