import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../services/clinic_services.dart';

Router clinicRoutes() {
  final router = Router();
  
  final patientService = PatientService(baseUrl: '', apiKey: '');
  final appointmentService = AppointmentService(baseUrl: '', apiKey: '');
  final doctorService = DoctorService(baseUrl: '', apiKey: '');

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      
      final patient = await patientService.createPatient(
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        dateOfBirth: json['date_of_birth'] as String,
        medicalHistory: json['medical_history'] as String? ?? '',
      );
      
      return Response.ok(jsonEncode(patient), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients', (Request request) async {
    try {
      final patients = await patientService.getPatients();
      return Response.ok(jsonEncode(patients), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients/<id>', (Request request, String id) async {
    try {
      final patient = await patientService.getPatientById(id);
      return Response.ok(jsonEncode(patient), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      
      final appointment = await appointmentService.createAppointment(
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        scheduledAt: json['scheduled_at'] as String,
        notes: json['notes'] as String? ?? '',
      );
      
      return Response.ok(jsonEncode(appointment), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/appointments', (Request request) async {
    try {
      final appointments = await appointmentService.getAppointments();
      return Response.ok(jsonEncode(appointments), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/doctors', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      
      final doctor = await doctorService.createDoctor(
        name: json['name'] as String,
        email: json['email'] as String,
        specialization: json['specialization'] as String,
        licenseNumber: json['license_number'] as String,
      );
      
      return Response.ok(jsonEncode(doctor), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/doctors', (Request request) async {
    try {
      final doctors = await doctorService.getDoctors();
      return Response.ok(jsonEncode(doctors), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  return router;
}
