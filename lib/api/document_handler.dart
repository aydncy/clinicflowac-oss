import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;
import '../domain/events/document_events.dart';
import '../domain/repositories/event_repository.dart';
import '../services/ovwi_client.dart';

class DocumentHandler {
  final EventRepository eventRepo;
  final OvwiClient ovwiClient;

  DocumentHandler(this.eventRepo, this.ovwiClient);

  Future<shelf.Response> upload(
    shelf.Request request,
    String appointmentId,
  ) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final documentId = 'doc_${DateTime.now().millisecondsSinceEpoch}';

      final event = DocumentEvents.uploaded(
        documentId: documentId,
        appointmentId: appointmentId,
        documentType: data['document_type'] as String,
        fileName: data['file_name'] as String,
      );

      await eventRepo.save(event);
      final proof = await ovwiClient.submitEvent(event);

      return shelf.Response.ok(
        jsonEncode({
          'document_id': documentId,
          'event_id': event.id,
          'appointment_id': appointmentId,
          'status': 'uploaded',
          'proof': {
            'hash': proof.hash,
            'signature': proof.signature,
            'sequence': proof.sequence,
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

  Future<shelf.Response> verify(
    shelf.Request request,
    String appointmentId,
  ) async {
    try {
      final payload = await request.readAsString();
      final data = jsonDecode(payload) as Map<String, dynamic>;

      final documentId = data['document_id'] as String;

      final event = DocumentEvents.verified(
        documentId: documentId,
        appointmentId: appointmentId,
      );

      await eventRepo.save(event);
      final proof = await ovwiClient.submitEvent(event);

      return shelf.Response.ok(
        jsonEncode({
          'document_id': documentId,
          'event_id': event.id,
          'status': 'verified',
          'proof': {
            'hash': proof.hash,
            'signature': proof.signature,
            'sequence': proof.sequence,
          }
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError();
    }
  }

  Future<shelf.Response> getDocuments(
    shelf.Request request,
    String appointmentId,
  ) async {
    try {
      final events = await eventRepo.getByAggregateId(appointmentId);
      final docEvents = events
          .where((e) => e.type.startsWith('document.'))
          .toList();

      if (docEvents.isEmpty) {
        return shelf.Response.notFound(
          jsonEncode({'error': 'No documents found'}),
        );
      }

      return shelf.Response.ok(
        jsonEncode({
          'appointment_id': appointmentId,
          'documents': docEvents.map((e) => e.toJson()).toList(),
          'count': docEvents.length,
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError();
    }
  }
}
