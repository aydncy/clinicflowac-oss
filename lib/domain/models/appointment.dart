enum AppointmentStatus { scheduled, confirmed, completed, cancelled, noshow }

class Appointment {
  final String id;
  final String patientId;
  final String clinicId;
  final String? doctorId;
  final DateTime scheduledTime;
  final AppointmentStatus status;
  final String? reason;
  final String? notes;
  final List<String> documentIds;
  final String? consentId;
  final DateTime createdAt;
  final DateTime? completedAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.clinicId,
    this.doctorId,
    required this.scheduledTime,
    required this.status,
    this.reason,
    this.notes,
    this.documentIds = const [],
    this.consentId,
    required this.createdAt,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'clinic_id': clinicId,
    'doctor_id': doctorId,
    'scheduled_time': scheduledTime.toIso8601String(),
    'status': status.toString().split('.').last,
    'reason': reason,
    'notes': notes,
    'document_ids': documentIds,
    'consent_id': consentId,
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    clinicId: json['clinic_id'] as String,
    doctorId: json['doctor_id'] as String?,
    scheduledTime: DateTime.parse(json['scheduled_time'] as String),
    status: AppointmentStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
    ),
    reason: json['reason'] as String?,
    notes: json['notes'] as String?,
    documentIds: List<String>.from(json['document_ids'] as List? ?? []),
    consentId: json['consent_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    completedAt: json['completed_at'] != null
        ? DateTime.parse(json['completed_at'] as String)
        : null,
  );
}
