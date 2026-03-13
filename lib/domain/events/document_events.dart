import 'event_envelope.dart';

class DocumentEvents {
  static WorkflowEvent uploaded({
    required String documentId,
    required String appointmentId,
    required String documentType,
    required String fileName,
  }) {
    return WorkflowEvent(
      id: 'evt_doc_uploaded_${DateTime.now().millisecondsSinceEpoch}',
      type: 'document.uploaded',
      ts: DateTime.now().toUtc(),
      actor: 'patient',
      entity: EntityRef(kind: 'document', id: documentId),
      data: {
        'appointment_id': appointmentId,
        'document_type': documentType,
        'file_name': fileName,
      },
    );
  }

  static WorkflowEvent verified({
    required String documentId,
    required String appointmentId,
  }) {
    return WorkflowEvent(
      id: 'evt_doc_verified_${DateTime.now().millisecondsSinceEpoch}',
      type: 'document.verified',
      ts: DateTime.now().toUtc(),
      actor: 'clinic',
      entity: EntityRef(kind: 'document', id: documentId),
      data: {'appointment_id': appointmentId},
    );
  }

  static WorkflowEvent rejected({
    required String documentId,
    required String appointmentId,
    required String reason,
  }) {
    return WorkflowEvent(
      id: 'evt_doc_rejected_${DateTime.now().millisecondsSinceEpoch}',
      type: 'document.rejected',
      ts: DateTime.now().toUtc(),
      actor: 'clinic',
      entity: EntityRef(kind: 'document', id: documentId),
      data: {
        'appointment_id': appointmentId,
        'reason': reason,
      },
    );
  }
}
