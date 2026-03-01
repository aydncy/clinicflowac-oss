// lib/data/demo_clinic.dart

import '../domain/events/event_envelope.dart';
import '../domain/events/event_factories.dart';

class DemoClinic {
  static List<WorkflowEvent> generateDemoEvents(String appointmentId) {
    return [
      EventFactories.appointmentCreated(
        appointmentId: appointmentId,
        startAt: DateTime.now().add(const Duration(hours: 2)),
        actor: 'clinic',
      ),
      WorkflowEvent(
        id: 'demo_cancel',
        type: 'appointment_cancelled',
        ts: DateTime.now().toUtc(),
        actor: 'clinic',
        entity: EntityRef(kind: 'appointment', id: appointmentId),
        data: {'reason': 'demo'},
      ),
    ];
  }
}
