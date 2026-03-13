class Diagnosis {
  final String icdCode;
  final String description;
  final bool isPrimary;

  Diagnosis({
    required this.icdCode,
    required this.description,
    required this.isPrimary,
  });

  Map<String, dynamic> toJson() => {
    'icd_code': icdCode,
    'description': description,
    'is_primary': isPrimary,
  };

  factory Diagnosis.fromJson(Map<String, dynamic> json) => Diagnosis(
    icdCode: json['icd_code'] as String,
    description: json['description'] as String,
    isPrimary: json['is_primary'] as bool? ?? false,
  );
}

class MedicalRecord {
  final String id;
  final String patientId;
  final String appointmentId;
  final String doctorId;
  final List<Diagnosis> diagnoses;
  final String? chiefComplaint;
  final String? examination;
  final String? assessment;
  final String? plan;
  final List<String> attachmentIds;
  final DateTime createdAt;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.appointmentId,
    required this.doctorId,
    required this.diagnoses,
    this.chiefComplaint,
    this.examination,
    this.assessment,
    this.plan,
    this.attachmentIds = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'appointment_id': appointmentId,
    'doctor_id': doctorId,
    'diagnoses': diagnoses.map((d) => d.toJson()).toList(),
    'chief_complaint': chiefComplaint,
    'examination': examination,
    'assessment': assessment,
    'plan': plan,
    'attachment_ids': attachmentIds,
    'created_at': createdAt.toIso8601String(),
  };

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
    id: json['id'] as String,
    patientId: json['patient_id'] as String,
    appointmentId: json['appointment_id'] as String,
    doctorId: json['doctor_id'] as String,
    diagnoses: (json['diagnoses'] as List)
        .map((d) => Diagnosis.fromJson(d as Map<String, dynamic>))
        .toList(),
    chiefComplaint: json['chief_complaint'] as String?,
    examination: json['examination'] as String?,
    assessment: json['assessment'] as String?,
    plan: json['plan'] as String?,
    attachmentIds: List<String>.from(json['attachment_ids'] as List? ?? []),
    createdAt: DateTime.parse(json['created_at'] as String),
  );
}
