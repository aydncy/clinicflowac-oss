import '../../domain/events/consent_events.dart';
import '../../services/ovwi_client.dart';

class RecordConsentRequest {
  final String appointmentId;
  final String patientId;
  final Map<String, bool> consentFields;

  RecordConsentRequest({
    required this.appointmentId,
    required this.patientId,
    required this.consentFields,
  });
}

class RecordConsentResponse {
  final String consentId;
  final String eventId;
  final Map<String, dynamic> proof;

  RecordConsentResponse({
    required this.consentId,
    required this.eventId,
    required this.proof,
  });
}

class RecordConsentUseCase {
  final OvwiClient ovwiClient;

  RecordConsentUseCase({required this.ovwiClient});

  Future<RecordConsentResponse> execute(RecordConsentRequest request) async {
    final consentId = 'consent_${DateTime.now().millisecondsSinceEpoch}';

    final event = ConsentEvents.recorded(
      consentId: consentId,
      appointmentId: request.appointmentId,
      patientId: request.patientId,
      consentFields: request.consentFields,
    );

    final proof = await ovwiClient.submitEvent(event);

    return RecordConsentResponse(
      consentId: consentId,
      eventId: event.id,
      proof: {
        'hash': proof.hash,
        'signature': proof.signature,
        'sequence': proof.sequence,
        'timestamp': proof.timestamp.toIso8601String(),
      },
    );
  }
}
