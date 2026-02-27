// lib/services/whatsapp_service.dart
import '../models/event.dart';

/// WhatsApp Cloud API webhook handler (starter)
class WhatsAppService {
  /// Incoming webhook payload from WhatsApp
  void handleWebhook(Map<String, dynamic> payload) {
    // Extract message content and sender
    final String sender = payload['entry']?[0]?['changes']?[0]?['value']?['contacts']?[0]?['wa_id'] ?? 'unknown';
    final String message = payload['entry']?[0]?['changes']?[0]?['value']?['messages']?[0]?['text']?['body'] ?? '';
    
    // Parse intent (simple keyword matching for MVP)
    final String intent = _parseIntent(message);
    
    // Create event
    final Event event
