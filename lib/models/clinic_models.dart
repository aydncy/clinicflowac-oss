class Patient {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String medicalHistory;
  final DateTime createdAt;

  Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.medicalHistory,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'medical_history': medicalHistory,
    'created_at': createdAt.toIso8601String(),
  };

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      medicalHistory: json['medical_history'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final String status;
  final String notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_id': patientId,
    'doctor_id': doctorId,
    'scheduled_at': scheduledAt.toIso8601String(),
    'status': status,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      patientId: json['patient_id'] as String,
      doctorId: json['doctor_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Doctor {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String licenseNumber;
  final DateTime createdAt;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.licenseNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'specialization': specialization,
    'license_number': licenseNumber,
    'created_at': createdAt.toIso8601String(),
  };

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      specialization: json['specialization'] as String,
      licenseNumber: json['license_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
