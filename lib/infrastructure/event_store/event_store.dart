import '../../domain/events/event_envelope.dart';

abstract class EventStore {
  Future<void> append(WorkflowEvent event);

  Future<List<WorkflowEvent>> loadByEntity({
    required String kind,
    required String id,
  });

  Future<List<WorkflowEvent>> loadAll();
}
