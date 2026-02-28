// lib/models/event.dart
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'aggregateId': aggregateId,
    'timestamp': timestamp.toIso8601String(),
    'actor': actor,
    if (payload != null) 'payload': payload,
  };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'] as String,
    type: EventType.values.firstWhere((e) => e.name == json['type']),
    aggregateId: json['aggregateId'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    actor: json['actor'] as String,
    payload: json['payload'] as Map<String, dynamic>?,
  );
}
