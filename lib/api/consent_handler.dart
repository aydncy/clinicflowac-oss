import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;
import '../domain/events/consent_events.dart';
import '../domain/repositories/event_repository.dart';
import '../services/ovwi_client.dart';

class ConsentHandler {
  final EventRepository eventRepo;
  final OvwiClient ovwiClient;

  ConsentHandler(this.eventRepo, this.ovwiClient);

  Future<shelf.Response> record(
    shelf.Request request,
    String appointmentId,
  ) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final consentId = 'consent_${DateTime.now().millisecondsSinceEpoch}';

      final event = ConsentEvents.recorded(
        consentId: consentId,
        appointmentId: appointmentId,
        patientId: data['patient_id'] as String,
        consentFields: Map<String, bool>.from(
          data['consent_fields'] as Map,
        ),
      );

      await eventRepo.save(event);
      final proof = await ovwiClient.submitEvent(event);

      return shelf.Response.ok(
        jsonEncode({
          'consent_id': consentId,
          'event_id': event.id,
          'appointment_id': appointmentId,
          'proof': {
            'hash': proof.hash,
            'signature': proof.signature,
            'sequence': proof.sequence,
            'timestamp': proof.timestamp.toIso8601String(),
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  Future<shelf.Response> get(
    shelf.Request request,
    String appointmentId,
  ) async {
    try {
      final events = await eventRepo.getByAggregateId(appointmentId);
      final consentEvents = events
          .where((e) => e.type.startsWith('consent.'))
          .toList();

      if (consentEvents.isEmpty) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'No consent found for this appointment'}),
        );
      }

      return shelf.Response.ok(
        jsonEncode({
          'appointment_id': appointmentId,
          'consents': consentEvents.map((e) => e.toJson()).toList(),
          'count': consentEvents.length,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError();
    }
  }
}
