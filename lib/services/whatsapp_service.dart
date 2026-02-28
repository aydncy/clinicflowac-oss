import 'package:clinicflowac/models/event.dart';

class WhatsAppService {
  String parseMessageIntent(String message) {
    final lower = message.toLowerCase();
    
    if (lower.contains('appoint') || lower.contains('book')) {
      return 'appointment_request';
    } else if (lower.contains('cancel')) {
      return 'appointment_cancel';
    } else if (lower.contains('reschedule') || lower.contains('change')) {
      return 'appointment_reschedule';
    }
    
    return 'unknown';
  }

  Event createEventFromMessage(String senderId, String message) {
    final intent = parseMessageIntent(message);
    
    return Event(
      id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
      type: intent,
      timestamp: DateTime.now(),
      actor: 'patient',
      entityKind: 'message',
      entityId: senderId,
      data: {'message': message, 'intent': intent},
    );
  }
}
