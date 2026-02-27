// lib/data/demo_clinic.dart
import '../models/event.dart';

class DemoClinic {
  static const String clinicName = "Demo Dental Clinic";
  static const String timezone = "Europe/Istanbul";
  static const String defaultProvider = "Dr. Demo";
  
  // Demo events - bu silinebilir, sadece demo için
  static List<Event> seedEvents = [
    Event(
      id: "demo-appointment-1",
      type: EventType.appointmentCreated,
      aggregateId: "appointment-001",
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      actor: "system",
      payload: {
        "patientName": "Ayşe Yılmaz",
        "date": "2026-02-28",
        "time": "14:00",
        "reason": "Routine checkup",
      },
    ),
    Event(
      id: "demo-document-1",
      type: EventType.documentUploaded,
      aggregateId: "appointment-001",
      timestamp: DateTime.now(),
      actor: "staff-001",
      payload: {
        "documentType": "ID card",
        "fileName": "ayse_yilmaz_id.jpg",
      },
    ),
  ];
}
