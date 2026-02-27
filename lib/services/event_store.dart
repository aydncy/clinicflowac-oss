// lib/services/event_store.dart
import '../models/event.dart';
import '../data/demo_clinic.dart';
import 'package:http/http.dart' as http;  // Webhook için

class EventStore {
  List<Event> _events = [];
  
  /// Get all events (append-only, never modified)
  List<Event> get events => List.unmodifiable(_events);
  
  /// Append new event (never overwrites)
  void append(Event event) {
    _events.add(event);
  }

  /// WhatsApp webhook simülasyonu için
  void simulateWhatsAppEvent(String message) {
    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      type: EventType.appointment_request,  // EventType enum'un yoksa string kullan
      data: {
        'message': message,
        'channel': 'whatsapp',
        'intent': _parseWhatsAppIntent(message),
      },
      actor: 'whatsapp_user_${DateTime.now().millisecond}',
    );
    append(event);  // append method'unu kullan
  }

  /// Basit WhatsApp intent parser (Türkçe/İngilizce)
  String _parseWhatsAppIntent(String message) {
    message = message.toLowerCase();
    if (message.contains('randevu') || message.contains('randevu al') || message.contains('appointment')) {
      return 'appointment_request';
    }
    if (message.contains('iptal') || message.contains('cancel')) {
      return 'appointment_cancel';
    }
    if (message.contains('hatırlatma') || message.contains('reminder')) {
      return 'reminder_sent';
    }
    return 'message_received';
  }

  /// Gerçek WhatsApp webhook handler (ileride kullanılacak)
  Future<void> handleWhatsAppWebhook(Map<String, dynamic> payload) async {
    final message = payload['entry']?[0]?['changes']?[0]?['value']?['messages']?[0]?['text']?['body'] ?? 'unknown';
    simulateWhatsAppEvent(message);
  }
}
