import 'event_envelope.dart';

class AppointmentEvents {
  static WorkflowEvent created({
    required String appointmentId,
    required String patientId,
    required String clinicId,
    required DateTime scheduledTime,
  }) {
    return WorkflowEvent(
      id: 'evt_apt_created_${DateTime.now().millisecondsSinceEpoch}',
      type: 'appointment.created',
      ts: DateTime.now().toUtc(),
      actor: 'clinic',
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {
        'patient_id': patientId,
        'clinic_id': clinicId,
        'scheduled_time': scheduledTime.toIso8601String(),
      },
    );
  }

  static WorkflowEvent confirmed({
    required String appointmentId,
    required String patientId,
  }) {
    return WorkflowEvent(
      id: 'evt_apt_confirmed_${DateTime.now().millisecondsSinceEpoch}',
      type: 'appointment.confirmed',
      ts: DateTime.now().toUtc(),
      actor: 'system',
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {'patient_id': patientId},
    );
  }

  static WorkflowEvent cancelled({
    required String appointmentId,
    required String reason,
  }) {
    return WorkflowEvent(
      id: 'evt_apt_cancelled_${DateTime.now().millisecondsSinceEpoch}',
      type: 'appointment.cancelled',
      ts: DateTime.now().toUtc(),
      actor: 'system',
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {'reason': reason},
    );
  }

  static WorkflowEvent completed({
    required String appointmentId,
  }) {
    return WorkflowEvent(
      id: 'evt_apt_completed_${DateTime.now().millisecondsSinceEpoch}',
      type: 'appointment.completed',
      ts: DateTime.now().toUtc(),
      actor: 'clinic',
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {},
    );
  }
}
