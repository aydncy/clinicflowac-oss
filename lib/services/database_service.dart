import 'package:drift/drift.dart';
import '../database/database.dart';

class PatientService {
  final AppDatabase db;

  PatientService(this.db);

  Future<Patient> registerPatient({
    required String clinicId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phone,
    String? email,
    String? bloodType,
    String? allergies,
  }) async {
    return db.createPatient(
      clinicId: clinicId,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      phone: phone,
      email: email,
      bloodType: bloodType,
      allergies: allergies,
    );
  }

  Future<List<Patient>> getClinicPatients(String clinicId) {
    return db.getClinicPatients(clinicId);
  }

  Future<Patient?> getPatient(String patientId) {
    return (db.select(db.patients)..where((p) => p.id.equals(patientId))).getSingleOrNull();
  }

  Future<void> updatePatient({
    required String patientId,
    String? phone,
    String? email,
    String? address,
  }) {
    return (db.update(db.patients)..where((p) => p.id.equals(patientId))).write(
      PatientsCompanion(
        phone: phone != null ? Value(phone) : const Value.absent(),
        email: email != null ? Value(email) : const Value.absent(),
        address: address != null ? Value(address) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deletePatient(String patientId) {
    return (db.delete(db.patients)..where((p) => p.id.equals(patientId))).go();
  }
}

class DoctorService {
  final AppDatabase db;

  DoctorService(this.db);

  Future<Doctor> registerDoctor({
    required String clinicId,
    required String firstName,
    required String lastName,
    required String email,
    required String licenseNumber,
    required String specialty,
  }) async {
    return db.createDoctor(
      clinicId: clinicId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      licenseNumber: licenseNumber,
      specialty: specialty,
    );
  }

  Future<List<Doctor>> getClinicDoctors(String clinicId) {
    return db.getClinicDoctors(clinicId);
  }

  Future<Doctor?> getDoctor(String doctorId) {
    return (db.select(db.doctors)..where((d) => d.id.equals(doctorId))).getSingleOrNull();
  }

  Future<List<Doctor>> searchDoctorsBySpecialty(String clinicId, String specialty) {
    return (db.select(db.doctors)
          ..where((d) => d.clinicId.equals(clinicId) & d.specialty.equals(specialty)))
        .get();
  }
}

class AppointmentService {
  final AppDatabase db;

  AppointmentService(this.db);

  Future<Appointment> scheduleAppointment({
    required String clinicId,
    required String patientId,
    required String doctorId,
    required DateTime appointmentTime,
    String? reasonForVisit,
    String? notes,
  }) async {
    return db.createAppointment(
      clinicId: clinicId,
      patientId: patientId,
      doctorId: doctorId,
      appointmentTime: appointmentTime,
      reasonForVisit: reasonForVisit,
      notes: notes,
    );
  }

  Future<List<Appointment>> getPatientAppointments(String patientId) {
    return db.getPatientAppointments(patientId);
  }

  Future<List<Appointment>> getDoctorAppointments(String doctorId) {
    return (db.select(db.appointments)..where((a) => a.doctorId.equals(doctorId))).get();
  }

  Future<void> completeAppointment(String appointmentId) {
    return (db.update(db.appointments)..where((a) => a.id.equals(appointmentId))).write(
      AppointmentsCompanion(
        isCompleted: const Value(true),
        status: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> cancelAppointment(String appointmentId) {
    return (db.update(db.appointments)..where((a) => a.id.equals(appointmentId))).write(
      AppointmentsCompanion(
        status: const Value('cancelled'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

class MedicalRecordService {
  final AppDatabase db;

  MedicalRecordService(this.db);

  Future<MedicalRecord> createRecord({
    required String clinicId,
    required String patientId,
    required String doctorId,
    String? appointmentId,
    String? diagnosis,
    String? symptoms,
    String? treatmentPlan,
  }) {
    return db.into(db.medicalRecords).insertReturning(
      MedicalRecordsCompanion(
        clinicId: Value(clinicId),
        patientId: Value(patientId),
        doctorId: Value(doctorId),
        appointmentId: appointmentId != null ? Value(appointmentId) : const Value.absent(),
        diagnosis: diagnosis != null ? Value(diagnosis) : const Value.absent(),
        symptoms: symptoms != null ? Value(symptoms) : const Value.absent(),
        treatmentPlan: treatmentPlan != null ? Value(treatmentPlan) : const Value.absent(),
      ),
    );
  }

  Future<List<MedicalRecord>> getPatientRecords(String patientId) {
    return (db.select(db.medicalRecords)..where((m) => m.patientId.equals(patientId))).get();
  }

  Future<MedicalRecord?> getRecord(String recordId) {
    return (db.select(db.medicalRecords)..where((m) => m.id.equals(recordId))).getSingleOrNull();
  }
}

class BillingService {
  final AppDatabase db;

  BillingService(this.db);

  Future<BillingInvoice> createInvoice({
    required String clinicId,
    required String patientId,
    required double amount,
    double? taxAmount,
    String? appointmentId,
  }) {
    final total = (taxAmount ?? 0) + amount;
    return db.into(db.billingInvoices).insertReturning(
      BillingInvoicesCompanion(
        clinicId: Value(clinicId),
        patientId: Value(patientId),
        amount: Value(amount),
        taxAmount: taxAmount != null ? Value(taxAmount) : const Value.absent(),
        totalAmount: Value(total),
        appointmentId: appointmentId != null ? Value(appointmentId) : const Value.absent(),
      ),
    );
  }

  Future<List<BillingInvoice>> getClinicInvoices(String clinicId) {
    return db.getClinicInvoices(clinicId);
  }

  Future<void> markAsPaid(String invoiceId) {
    return (db.update(db.billingInvoices)..where((i) => i.id.equals(invoiceId))).write(
      BillingInvoicesCompanion(
        status: const Value('paid'),
        paymentDate: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

class AuditService {
  final AppDatabase db;

  AuditService(this.db);

  Future<void> logAction({
    required String clinicId,
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
  }) {
    return db.logAuditAction(
      clinicId: clinicId,
      action: action,
      entityType: entityType,
      entityId: entityId,
      oldValues: oldValues,
      newValues: newValues,
    );
  }

  Future<List<AuditLog>> getClinicLogs(String clinicId) {
    return (db.select(db.auditLogs)..where((a) => a.clinicId.equals(clinicId))).get();
  }
}
