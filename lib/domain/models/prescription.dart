class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final int duration;
  final String? instructions;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.duration,
    this.instructions,
  });

  
    'name': name,
    'dosage': dosage,
    'frequency': frequency,
    'duration': duration,
    'instructions': instructions,
  };

  
    name: json['name'] as String,
    dosage: json['dosage'] as String,
    frequency: json['frequency'] as String,
    duration: json['duration'] as int,
    instructions: json['instructions'] as String?,
  );
}

enum PrescriptionStatus { issued, filled, completed, cancelled }

class Prescription {
  final String id;
  final String appointmentId;
  final String patientId;
  final String doctorId;
  final List<Medication> medications;
  final PrescriptionStatus status;
  final DateTime issuedAt;
  final DateTime? filledAt;
  final String? pharmacyId;
  final String? notes;

  Prescription({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.doctorId,
    required this.medications,
    required this.status,
    required this.issuedAt,
    this.filledAt,
    this.pharmacyId,
    this.notes,
  });

  
    'id': id,
    'appointment_id': appointmentId,
    'patient_id': patientId,
    'doctor_id': doctorId,
    'medications': medications.map((m) => m.toJson()).toList(),
    'status': status.toString().split('.').last,
    'issued_at': issuedAt.toIso8601String(),
    'filled_at': filledAt?.toIso8601String(),
    'pharmacy_id': pharmacyId,
    'notes': notes,
  };

  
    id: json['id'] as String,
    appointmentId: json['appointment_id'] as String,
    patientId: json['patient_id'] as String,
    doctorId: json['doctor_id'] as String,
    medications: (json['medications'] as List)
        .map((m) => Medication.fromJson(m as Map<String, dynamic>))
        .toList(),
    status: PrescriptionStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['status'],
    ),
    issuedAt: DateTime.parse(json['issued_at'] as String),
    filledAt: json['filled_at'] != null
        ? DateTime.parse(json['filled_at'] as String)
        : null,
    pharmacyId: json['pharmacy_id'] as String?,
    notes: json['notes'] as String?,
  );
}
