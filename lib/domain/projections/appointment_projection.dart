import '../events/event_envelope.dart';

enum AppointmentStatus { created, rescheduled, cancelled, unknown }

class AppointmentSnapshot {
  final String appointmentId;
  final AppointmentStatus status;
  final DateTime? scheduledAt;
  final String? lastMessage;
  final int eventCount;

  AppointmentSnapshot({
    required this.appointmentId,
    required this.status,
    this.scheduledAt,
    this.lastMessage,
    required this.eventCount,
  });
}

class AppointmentProjection {
  AppointmentSnapshot project(String appointmentId, List<WorkflowEvent> events) {
    AppointmentStatus status = AppointmentStatus.unknown;
    DateTime? scheduledAt;
    String? lastMessage;

    for (final e in events) {
      switch (e.type) {
        case 'appointment_created':
          status = AppointmentStatus.created;
          scheduledAt = e.ts;
          break;
        case 'appointment_rescheduled':
          status = AppointmentStatus.rescheduled;
          scheduledAt = e.ts;
          break;
        case 'appointment_cancelled':
          status = AppointmentStatus.cancelled;
          break;
        case 'message_captured':
          lastMessage = e.data['message'] as String?;
          break;
      }
    }

    return AppointmentSnapshot(
      appointmentId: appointmentId,
      status: status,
      scheduledAt: scheduledAt,
      lastMessage: lastMessage,
      eventCount: events.length,
    );
  }
}
