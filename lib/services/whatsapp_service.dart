// lib/services/whatsapp_service.dart

import '../domain/events/event_envelope.dart';
import '../shared/ids.dart';

/// WhatsAppService
///
/// Converts incoming WhatsApp webhook payloads into
/// WES-compliant WorkflowEvent objects.
///
/// This service does NOT contain business logic.
/// It only translates external messages into domain events.
class WhatsAppService {
  /// Callback triggered whenever a WES event is produced.
  final void Function(WorkflowEvent) onEvent;

  WhatsAppService({required this.onEvent});

  /// Entry point for WhatsApp webhook handling.
  void handleWebhook(Map<String, dynamic> payload) {
    final senderId = _extractSender(payload);
    final message = _extractMessage(payload);

    final eventType = _determineEventType(message);

    final event = WorkflowEvent(
      id: Ids.newId(),
      type: eventType,
      ts: DateTime.now().toUtc(),
      actor: 'integration', // system | patient | clinic | integration
      entity: EntityRef(
        kind: 'appointment', // MVP assumption
        id: senderId,
      ),
      data: {
        'channel': 'whatsapp',
        'sender_id': senderId,
        'message': message,
      },
    );

    onEvent(event);
  }

  // -------------------------
  // Payload Extraction
  // -------------------------

  String _extractSender(Map<String, dynamic> payload) {
    try {
      return payload['entry'][0]['changes'][0]['value']['contacts'][0]['wa_id']
          as String;
    } catch (_) {
      return 'unknown_sender';
    }
  }

  String _extractMessage(Map<String, dynamic> payload) {
    try {
      return payload['entry'][0]['changes'][0]['value']['messages'][0]['text']
          ['body'] as String;
    } catch (_) {
      return '';
    }
  }

  // -------------------------
  // Intent Parsing
  // -------------------------

  /// Maps message content to WES event type strings.
  String _determineEventType(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('randevu') &&
        (lower.contains('al') || lower.contains('oluştur'))) {
      return 'appointment_created';
    }

    if (lower.contains('iptal')) {
      return 'appointment_cancelled';
    }

    if (lower.contains('ertele') ||
        lower.contains('tarihi değiştir') ||
        lower.contains('değiştir')) {
      return 'appointment_rescheduled';
    }

    return 'message_received';
  }
}
