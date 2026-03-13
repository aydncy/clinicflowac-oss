import '../../shared/ids.dart';
import 'event_envelope.dart';

/// Bridge that converts data from old sources to WES (WorkflowEvent) format.
/// Thus we use a SINGLE event model in the application.
class WesBridge {
  /// Basit "metin mesajı" -> event
  static WorkflowEvent messageCaptured({
    required String appointmentId,
    required String channel, // "whatsapp" | "sms" | "email"
    required String message,
  }) {
    return WorkflowEvent(
      id: Ids.newId(),
      type: 'message_captured',
      ts: DateTime.now().toUtc(),
      actor: 'integration',
      entity: EntityRef(kind: 'appointment', id: appointmentId),
      data: {
        'channel': channel,
        'message': message,
      },
    );
  }
}
