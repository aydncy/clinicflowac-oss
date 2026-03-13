import 'package:postgres/postgres.dart';

class PostgresRepository {
  late Connection _connection;

  Future<void> connect({
    String host = 'localhost',
    int port = 5432,
    String database = 'clinicflow',
    String username = 'postgres',
    String password = 'postgres',
  }) async {
    _connection = await Connection.open(
      Endpoint(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
      ),
    );
    print('✅ ClinicFlow PostgreSQL connected');
  }

  Future<void> initializeDatabase() async {
    await _connection.execute('''
      CREATE TABLE IF NOT EXISTS patients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        date_of_birth DATE NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS appointments (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL REFERENCES patients(id),
        doctor_id TEXT NOT NULL,
        clinic_id TEXT NOT NULL,
        scheduled_at TIMESTAMP NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS documents (
        id TEXT PRIMARY KEY,
        appointment_id TEXT NOT NULL REFERENCES appointments(id),
        filename TEXT NOT NULL,
        status TEXT NOT NULL,
        verified_at TIMESTAMP,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS consents (
        id TEXT PRIMARY KEY,
        appointment_id TEXT NOT NULL REFERENCES appointments(id),
        patient_id TEXT NOT NULL REFERENCES patients(id),
        consent_type TEXT NOT NULL,
        recorded_at TIMESTAMP NOT NULL,
        signature TEXT NOT NULL,
        verified BOOLEAN DEFAULT false,
        created_at TIMESTAMP NOT NULL DEFAULT NOW()
      );

      CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments(patient_id);
      CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);
      CREATE INDEX IF NOT EXISTS idx_documents_appointment ON documents(appointment_id);
      CREATE INDEX IF NOT EXISTS idx_consents_patient ON consents(patient_id);
    ''');
    print('✅ ClinicFlow database initialized');
  }

  Future<void> insertPatient({
    required String id,
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfBirth,
  }) async {
    await _connection.execute(
      '''
      INSERT INTO patients (id, name, email, phone, date_of_birth)
      VALUES (@id, @name, @email, @phone, @dob)
      ''',
      substitutionValues: {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dateOfBirth,
      },
    );
  }

  Future<Map<String, dynamic>?> getPatient(String id) async {
    final results = await _connection.query(
      'SELECT * FROM patients WHERE id = @id',
      substitutionValues: {'id': id},
    );
    if (results.isEmpty) return null;
    return results.first.toColumnMap() as Map<String, dynamic>;
  }

  Future<void> insertAppointment({
    required String id,
    required String patientId,
    required String doctorId,
    required String clinicId,
    required DateTime scheduledAt,
    required String status,
  }) async {
    await _connection.execute(
      '''
      INSERT INTO appointments 
      (id, patient_id, doctor_id, clinic_id, scheduled_at, status)
      VALUES (@id, @patientId, @doctorId, @clinicId, @scheduledAt, @status)
      ''',
      substitutionValues: {
        'id': id,
        'patientId': patientId,
        'doctorId': doctorId,
        'clinicId': clinicId,
        'scheduledAt': scheduledAt,
        'status': status,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAppointmentsByPatient(String patientId) async {
    final results = await _connection.query(
      'SELECT * FROM appointments WHERE patient_id = @patientId ORDER BY scheduled_at DESC',
      substitutionValues: {'patientId': patientId},
    );
    return results.map((row) => row.toColumnMap() as Map<String, dynamic>).toList();
  }

  Future<void> insertConsent({
    required String id,
    required String appointmentId,
    required String patientId,
    required String consentType,
    required String signature,
  }) async {
    await _connection.execute(
      '''
      INSERT INTO consents 
      (id, appointment_id, patient_id, consent_type, recorded_at, signature, verified)
      VALUES (@id, @appointmentId, @patientId, @consentType, @recordedAt, @signature, true)
      ''',
      substitutionValues: {
        'id': id,
        'appointmentId': appointmentId,
        'patientId': patientId,
        'consentType': consentType,
        'recordedAt': DateTime.now(),
        'signature': signature,
      },
    );
  }

  Future<void> close() async {
    await _connection.close();
    print('✅ ClinicFlow PostgreSQL disconnected');
  }
}
