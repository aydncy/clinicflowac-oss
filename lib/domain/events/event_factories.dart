// lib/domain/events/event_factories.dart
import '../../shared/ids.dart';
import 'event_envelope.dart';

class EventFactories {
  static WorkflowEvent appointmentCreated({
    required String appointmentId,
    required DateTime startAt,
    required String actor, // system|patient|clinic|integration
  }) {
    return WorkflowEvent(
      id: Ids.newId(),
      type: 'appointment_created',
      ts: DateTime.now().toUtc(),
      actor: actor,
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {
        'start_at': startAt.toUtc().toIso8601String(),
      },
    );
  }

  static WorkflowEvent documentRequested({
    required String documentId,
    required String docType, // e.g. "kimlik", "rapor"
    required String actor,
  }) {
    return WorkflowEvent(
      id: Ids.newId(),
      type: 'document_requested',
      ts: DateTime.now().toUtc(),
      actor: actor,
      entity: EntityRef(kind: 'document', id: documentId),
      data: {
        'doc_type': docType,
      },
    );
  }

  static WorkflowEvent consentGiven({
    required String consentId,
    required String consentType, // e.g. "kvkk", "treatment"
    required String actor,
  }) {
    return WorkflowEvent(
      id: Ids.newId(),
      type: 'consent_given',
      ts: DateTime.now().toUtc(),
      actor: actor,
      entity: EntityRef(kind: 'consent', id: consentId),
      data: {
        'consent_type': consentType,
      },
    );
  }

  static WorkflowEvent noteAdded({
    required String appointmentId,
    required String note,
    required String actor,
  }) {
    return WorkflowEvent(
      id: Ids.newId(),
      type: 'note_added',
      ts: DateTime.now().toUtc(),
      actor: actor,
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {
        'note': note,
      },
    );
  }
}
