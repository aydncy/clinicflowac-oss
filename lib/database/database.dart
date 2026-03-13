import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Clinics,
  Doctors,
  Patients,
  Appointments,
  MedicalRecords,
  Prescriptions,
  BillingInvoices,
  AuditLogs,
  Notifications,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<Clinic> createClinic({
    required String name,
    required String email,
    required String phone,
    required String licenseNumber,
  }) {
    return into(clinics).insertReturning(
      ClinicsCompanion(
        name: Value(name),
        email: Value(email),
        phone: Value(phone),
        licenseNumber: Value(licenseNumber),
      ),
    );
  }

  Future<Patient> createPatient({
    required String clinicId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phone,
    String? email,
    String? bloodType,
    String? allergies,
  }) {
    return into(patients).insertReturning(
      PatientsCompanion(
        clinicId: Value(clinicId),
        firstName: Value(firstName),
        lastName: Value(lastName),
        dateOfBirth: Value(dateOfBirth),
        phone: Value(phone),
        email: Value(email),
        bloodType: Value(bloodType),
        allergies: Value(allergies),
      ),
    );
  }

  Future<Doctor> createDoctor({
    required String clinicId,
    required String firstName,
    required String lastName,
    required String email,
    required String licenseNumber,
    required String specialty,
  }) {
    return into(doctors).insertReturning(
      DoctorsCompanion(
        clinicId: Value(clinicId),
        firstName: Value(firstName),
        lastName: Value(lastName),
        email: Value(email),
        licenseNumber: Value(licenseNumber),
        specialty: Value(specialty),
      ),
    );
  }

  Future<Appointment> createAppointment({
    required String clinicId,
    required String patientId,
    required String doctorId,
    required DateTime appointmentTime,
    String? reasonForVisit,
    String? notes,
  }) {
    return into(appointments).insertReturning(
      AppointmentsCompanion(
        clinicId: Value(clinicId),
        patientId: Value(patientId),
        doctorId: Value(doctorId),
        appointmentTime: Value(appointmentTime),
        reasonForVisit: Value(reasonForVisit),
        notes: Value(notes),
      ),
    );
  }

  Future<List<Patient>> getClinicPatients(String clinicId) {
    return (select(patients)..where((p) => p.clinicId.equals(clinicId))).get();
  }

  Future<List<Doctor>> getClinicDoctors(String clinicId) {
    return (select(doctors)..where((d) => d.clinicId.equals(clinicId))).get();
  }

  Future<List<Appointment>> getPatientAppointments(String patientId) {
    return (select(appointments)..where((a) => a.patientId.equals(patientId))).get();
  }

  Future<List<BillingInvoice>> getClinicInvoices(String clinicId) {
    return (select(billingInvoices)..where((i) => i.clinicId.equals(clinicId))).get();
  }

  Future<void> logAuditAction({
    required String clinicId,
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? oldValues,
    Map<String, dynamic>? newValues,
  }) {
    return into(auditLogs).insert(
      AuditLogsCompanion(
        clinicId: Value(clinicId),
        action: Value(action),
        entityType: Value(entityType),
        entityId: Value(entityId),
        oldValues: Value(oldValues.toString()),
        newValues: Value(newValues.toString()),
      ),
    );
  }
}

QueryExecutor _openConnection() {
  return PgDatabase(
    host: 'localhost',
    port: 5432,
    user: 'postgres',
    password: 'password',
    database: 'clinicflowac',
  );
}
