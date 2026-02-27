// lib/models/event.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

enum EventType {
  /// Appointment lifecycle
  appointmentCreated,
  appointmentRescheduled,
  appointmentCancelled,
  
  /// Document workflow
  documentRequested,
  documentUploaded,
  documentRejected,
  documentApproved,
  
  /// Consent
  consentGiven,
  consentRevoked,
  consentExpired,
  
  /// Messaging
  messageReceived,
  messageSent,
  reminderScheduled,
  reminderSent,
  
  /// Audit
  proofPackExported,
}

@freezed
class Event with _$Event {
  const factory Event({
    /// Unique event ID
    required String id,
    
    /// What kind of thing changed
    required EventType type,
    
    /// Which aggregate this applies to (appointment ID, patient ID, etc.)
    required String aggregateId,
    
    /// When it happened
    required DateTime timestamp,
    
    /// Who/what caused it
    required String actor, // staff ID, "system", "patient", etc.
    
    /// Event-specific data
    @JsonKey(includeIfNull: false) 
    Map<String, dynamic>? payload,
  }) = _Event;

  /// JSON serialization
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
