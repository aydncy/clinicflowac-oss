import '../../shared/ids.dart';
import 'event_envelope.dart';

/// Eski yerlerden gelen veriyi WES (WorkflowEvent) formatına çeviren köprü.
/// Böylece uygulamada TEK event modeli kullanırız.
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
