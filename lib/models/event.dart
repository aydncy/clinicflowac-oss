enum EventType {
  appointmentCreated,
  appointmentRescheduled,
  appointmentCancelled,
  documentRequested,
  documentUploaded,
  documentRejected,
  documentApproved,
  consentGiven,
  consentRevoked,
  consentExpired,
  messageReceived,
  messageSent,
  reminderScheduled,
  reminderSent,
  proofPackExported,
}

class Event {
  final String id;
  final EventType type;
  final String aggregateId;
  final DateTime timestamp;
  final String actor;
  final Map<String, dynamic>? payload;

  const Event({
    required this.id,
    required this.type,
    required this.aggregateId,
    required this.timestamp,
    required this.actor,
    this.payload,
  });
}
