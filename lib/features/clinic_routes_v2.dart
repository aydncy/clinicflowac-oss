import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../services/db_service.dart';

Router clinicRoutes(DatabaseService db) {
  final router = Router();

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? 'clinic_001';

      final patient = await db.createPatient(
        clinicId: clinicId,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
        phone: json['phone'] as String,
        email: json['email'] as String?,
        bloodType: json['blood_type'] as String?,
        allergies: json['allergies'] as String?,
      );

      return Response.ok(jsonEncode(patient), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients', (Request request) async {
    try {
      final clinicId = request.headers['clinic-id'] ?? 'clinic_001';
      final patients = await db.getPatients(clinicId);
      return Response.ok(jsonEncode(patients), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/doctors', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? 'clinic_001';

      final doctor = await db.createDoctor(
        clinicId: clinicId,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        licenseNumber: json['license_number'] as String,
        specialty: json['specialty'] as String,
      );

      return Response.ok(jsonEncode(doctor), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/doctors', (Request request) async {
    try {
      final clinicId = request.headers['clinic-id'] ?? 'clinic_001';
      final doctors = await db.getDoctors(clinicId);
      return Response.ok(jsonEncode(doctors), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? 'clinic_001';

      final appointment = await db.createAppointment(
        clinicId: clinicId,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        appointmentTime: DateTime.parse(json['appointment_time'] as String),
        reasonForVisit: json['reason_for_visit'] as String?,
        notes: json['notes'] as String?,
      );

      return Response.ok(jsonEncode(appointment), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/appointments', (Request request) async {
    try {
      final patientId = request.url.queryParameters['patient_id'] ?? '';
      final appointments = await db.getAppointments(patientId);
      return Response.ok(jsonEncode(appointments), headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  return router;
}
