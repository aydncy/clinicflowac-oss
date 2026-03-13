import 'dart:convert';

class PatientService {
  final String baseUrl;
  final String apiKey;

  PatientService({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> createPatient({
    required String name,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String medicalHistory,
  }) async {
    return {
      'id': 'pat_' + DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'medical_history': medicalHistory,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    return [];
  }

  Future<Map<String, dynamic>> getPatientById(String patientId) async {
    return {
      'id': patientId,
      'name': 'Patient Name',
      'email': 'patient@example.com',
    };
  }
}

class AppointmentService {
  final String baseUrl;
  final String apiKey;

  AppointmentService({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> createAppointment({
    required String patientId,
    required String doctorId,
    required String scheduledAt,
    required String notes,
  }) async {
    return {
      'id': 'apt_' + DateTime.now().millisecondsSinceEpoch.toString(),
      'patient_id': patientId,
      'doctor_id': doctorId,
      'scheduled_at': scheduledAt,
      'status': 'scheduled',
      'notes': notes,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    return [];
  }
}

class DoctorService {
  final String baseUrl;
  final String apiKey;

  DoctorService({required this.baseUrl, required this.apiKey});

  Future<Map<String, dynamic>> createDoctor({
    required String name,
    required String email,
    required String specialization,
    required String licenseNumber,
  }) async {
    return {
      'id': 'doc_' + DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'specialization': specialization,
      'license_number': licenseNumber,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Future<List<Map<String, dynamic>>> getDoctors() async {
    return [];
  }
}
