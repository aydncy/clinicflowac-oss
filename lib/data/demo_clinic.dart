// lib/data/demo_clinic.dart
import '../models/event.dart';

class DemoClinic {
  static const String clinicName = "Demo Dental Clinic";
  static const String timezone = "Europe/Istanbul";
  static const String defaultProvider = "Dr. Demo";

  /// Demo seed events
  static List<Event> seedEvents = [
    Event(
      id: "evt-001",
      type: EventType.appointmentCreated,
      aggregateId: "appointment-001",
      timestamp: DateTime(2026, 2, 28, 14, 0),
      actor: "system",
      payload: {
        "patientName": "Ayşe Yılmaz",
        "date": "2026-02-28",
        "time": "14:00",
        "reason": "Routine checkup",
      },
    ),
    Event(
      id: "evt-002",
      type: EventType.documentUploaded,
      aggregateId: "appointment-001",
      timestamp: DateTime(2026, 2, 28, 14, 30),
      actor: "staff-001",
      payload: {
        "documentType": "ID card",
        "fileName": "ayse_yilmaz_id.jpg",
      },
    ),
  ];
}
