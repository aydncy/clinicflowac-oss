// lib/services/whatsapp_service.dart
import 'dart:math';
import '../models/event.dart';

class WhatsAppService {
  final void Function(Event) onEvent;

  WhatsAppService({required this.onEvent});

  /// Handle incoming WhatsApp webhook payload
  void handleWebhook(Map<String, dynamic> payload) {
    final sender = _extractSender(payload);
    final message = _extractMessage(payload);
    final intent = _parseIntent(message);

    final event = Event(
      id: _generateId(),
      type: intent,
      aggregateId: sender,
      timestamp: DateTime.now(),
      actor: sender,
      payload: {'rawMessage': message},
    );

    onEvent(event);
  }

  String _extractSender(Map<String, dynamic> payload) {
    try {
      return payload['entry'][0]['changes'][0]['value']
          ['contacts'][0]['wa_id'] as String;
    } catch (_) {
      return 'unknown';
    }
  }

  String _extractMessage(Map<String, dynamic> payload) {
    try {
      return payload['entry'][0]['changes'][0]['value']
          ['messages'][0]['text']['body'] as String;
    } catch (_) {
      return '';
    }
  }

  EventType _parseIntent(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('randevu') && lower.contains('al')) {
      return EventType.appointmentCreated;
    } else if (lower.contains('iptal')) {
      return EventType.appointmentCancelled;
    } else if (lower.contains('ertele')) {
      return EventType.appointmentRescheduled;
    } else {
      return EventType.messageReceived;
    }
  }

  String _generateId() =>
      Random().nextInt(999999).toString().padLeft(6, '0');
}
