import '../../domain/events/event_envelope.dart';
import '../../infrastructure/event_store/event_store.dart';

class DemoPipeline {
  final EventStore store;

  DemoPipeline({required this.store});

  Future<void> handleEvent(WorkflowEvent event) async {
    await store.append(event);
  }

  Future<List<WorkflowEvent>> loadTimelineForAppointment(String appointmentId) async {
    return store.loadByEntity(kind: 'appointment', id: appointmentId);
  }
}
