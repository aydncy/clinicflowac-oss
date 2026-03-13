import 'event_envelope.dart';

class ConsentEvents {
  static WorkflowEvent recorded({
    required String consentId,
    required String appointmentId,
    required String patientId,
    required Map<String, bool> consentFields,
  }) {
    return WorkflowEvent(
      id: 'evt_consent_recorded_${DateTime.now().millisecondsSinceEpoch}',
      type: 'consent.recorded',
      ts: DateTime.now().toUtc(),
      actor: 'patient',
      entity: EntityRef(kind: 'consent', id: consentId),
      data: {
        'appointment_id': appointmentId,
        'patient_id': patientId,
        'consent_fields': consentFields,
      },
    );
  }

  static WorkflowEvent verified({
    required String consentId,
    required String appointmentId,
  }) {
    return WorkflowEvent(
      id: 'evt_consent_verified_${DateTime.now().millisecondsSinceEpoch}',
      type: 'consent.verified',
      ts: DateTime.now().toUtc(),
      actor: 'system',
      entity: EntityRef(kind: 'consent', id: consentId),
      data: {'appointment_id': appointmentId},
    );
  }

  static WorkflowEvent revoked({
    required String consentId,
    required String appointmentId,
    required String reason,
  }) {
    return WorkflowEvent(
      id: 'evt_consent_revoked_${DateTime.now().millisecondsSinceEpoch}',
      type: 'consent.revoked',
      ts: DateTime.now().toUtc(),
      actor: 'patient',
      entity: EntityRef(kind: 'consent', id: consentId),
      data: {
        'appointment_id': appointmentId,
        'reason': reason,
      },
    );
  }
}
