import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../database/database.dart';
import '../services/database_service.dart';

Router clinicRoutes(AppDatabase db) {
  final router = Router();
  
  final patientService = PatientService(db);
  final doctorService = DoctorService(db);
  final appointmentService = AppointmentService(db);
  final medicalRecordService = MedicalRecordService(db);
  final billingService = BillingService(db);
  final auditService = AuditService(db);

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? '';

      final patient = await patientService.registerPatient(
        clinicId: clinicId,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
        phone: json['phone'] as String,
        email: json['email'] as String?,
        bloodType: json['blood_type'] as String?,
        allergies: json['allergies'] as String?,
      );

      await auditService.logAction(
        clinicId: clinicId,
        action: 'CREATE',
        entityType: 'Patient',
        entityId: patient.id.toString(),
        newValues: json,
      );

      return Response.ok(
        jsonEncode({'id': patient.id, 'status': 'created'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients', (Request request) async {
    try {
      final clinicId = request.headers['clinic-id'] ?? '';
      final patients = await patientService.getClinicPatients(clinicId);
      return Response.ok(
        jsonEncode(patients.map((p) => {'id': p.id, 'first_name': p.firstName, 'last_name': p.lastName}).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/doctors', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? '';

      final doctor = await doctorService.registerDoctor(
        clinicId: clinicId,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        email: json['email'] as String,
        licenseNumber: json['license_number'] as String,
        specialty: json['specialty'] as String,
      );

      return Response.ok(
        jsonEncode({'id': doctor.id, 'status': 'registered'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/doctors', (Request request) async {
    try {
      final clinicId = request.headers['clinic-id'] ?? '';
      final doctors = await doctorService.getClinicDoctors(clinicId);
      return Response.ok(
        jsonEncode(doctors.map((d) => {'id': d.id, 'name': '${d.firstName} ${d.lastName}', 'specialty': d.specialty}).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? '';

      final appointment = await appointmentService.scheduleAppointment(
        clinicId: clinicId,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        appointmentTime: DateTime.parse(json['appointment_time'] as String),
        reasonForVisit: json['reason_for_visit'] as String?,
        notes: json['notes'] as String?,
      );

      return Response.ok(
        jsonEncode({'id': appointment.id, 'status': 'scheduled'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/appointments', (Request request) async {
    try {
      final patientId = request.url.queryParameters['patient_id'] ?? '';
      final appointments = await appointmentService.getPatientAppointments(patientId);
      return Response.ok(
        jsonEncode(appointments.map((a) => {'id': a.id, 'appointment_time': a.appointmentTime, 'status': a.status}).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/medical-records', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? '';

      final record = await medicalRecordService.createRecord(
        clinicId: clinicId,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        appointmentId: json['appointment_id'] as String?,
        diagnosis: json['diagnosis'] as String?,
        symptoms: json['symptoms'] as String?,
        treatmentPlan: json['treatment_plan'] as String?,
      );

      return Response.ok(
        jsonEncode({'id': record.id, 'status': 'recorded'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/billing/invoices', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;
      final clinicId = request.headers['clinic-id'] ?? '';

      final invoice = await billingService.createInvoice(
        clinicId: clinicId,
        patientId: json['patient_id'] as String,
        amount: (json['amount'] as num).toDouble(),
        taxAmount: json['tax_amount'] != null ? (json['tax_amount'] as num).toDouble() : null,
        appointmentId: json['appointment_id'] as String?,
      );

      return Response.ok(
        jsonEncode({'id': invoice.id, 'total_amount': invoice.totalAmount, 'status': 'pending'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  return router;
}
