import 'package:postgres/postgres.dart';

class DatabaseService {
  late Connection conn;

  Future<void> connect() async {
    conn = await Connection.open(
      Endpoint(
        host: 'localhost',
        port: 5432,
        database: 'clinicflowac',
        username: 'postgres',
        password: 'password',
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    print('Database connected');
  }

  Future<Map<String, dynamic>> createPatient({
    required String clinicId,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required String phone,
    String? email,
    String? bloodType,
    String? allergies,
  }) async {
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO patients 
        (clinic_id, first_name, last_name, date_of_birth, phone, email, blood_type, allergies)
        VALUES (@clinic_id, @first_name, @last_name, @date_of_birth, @phone, @email, @blood_type, @allergies)
        RETURNING id, first_name, last_name, created_at
      '''),
      parameters: {
        'clinic_id': clinicId,
        'first_name': firstName,
        'last_name': lastName,
        'date_of_birth': dateOfBirth,
        'phone': phone,
        'email': email,
        'blood_type': bloodType,
        'allergies': allergies,
      },
    );
    return {
      'id': result[0][0],
      'first_name': result[0][1],
      'last_name': result[0][2],
      'created_at': result[0][3],
    };
  }

  Future<List<Map<String, dynamic>>> getPatients(String clinicId) async {
    final result = await conn.execute(
      Sql.named('SELECT id, first_name, last_name, phone, email FROM patients WHERE clinic_id = @clinic_id'),
      parameters: {'clinic_id': clinicId},
    );
    return result.map((r) => {
      'id': r[0],
      'first_name': r[1],
      'last_name': r[2],
      'phone': r[3],
      'email': r[4],
    }).toList();
  }

  Future<Map<String, dynamic>> createDoctor({
    required String clinicId,
    required String firstName,
    required String lastName,
    required String email,
    required String licenseNumber,
    required String specialty,
  }) async {
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO doctors 
        (clinic_id, first_name, last_name, email, license_number, specialty)
        VALUES (@clinic_id, @first_name, @last_name, @email, @license_number, @specialty)
        RETURNING id, first_name, last_name
      '''),
      parameters: {
        'clinic_id': clinicId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'license_number': licenseNumber,
        'specialty': specialty,
      },
    );
    return {
      'id': result[0][0],
      'first_name': result[0][1],
      'last_name': result[0][2],
    };
  }

  Future<List<Map<String, dynamic>>> getDoctors(String clinicId) async {
    final result = await conn.execute(
      Sql.named('SELECT id, first_name, last_name, specialty FROM doctors WHERE clinic_id = @clinic_id'),
      parameters: {'clinic_id': clinicId},
    );
    return result.map((r) => {
      'id': r[0],
      'first_name': r[1],
      'last_name': r[2],
      'specialty': r[3],
    }).toList();
  }

  Future<Map<String, dynamic>> createAppointment({
    required String clinicId,
    required String patientId,
    required String doctorId,
    required DateTime appointmentTime,
    String? reasonForVisit,
    String? notes,
  }) async {
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO appointments 
        (clinic_id, patient_id, doctor_id, appointment_time, reason_for_visit, notes)
        VALUES (@clinic_id, @patient_id, @doctor_id, @appointment_time, @reason_for_visit, @notes)
        RETURNING id, appointment_time, status
      '''),
      parameters: {
        'clinic_id': clinicId,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'appointment_time': appointmentTime,
        'reason_for_visit': reasonForVisit,
        'notes': notes,
      },
    );
    return {
      'id': result[0][0],
      'appointment_time': result[0][1],
      'status': result[0][2],
    };
  }

  Future<List<Map<String, dynamic>>> getAppointments(String patientId) async {
    final result = await conn.execute(
      Sql.named('SELECT id, appointment_time, status FROM appointments WHERE patient_id = @patient_id'),
      parameters: {'patient_id': patientId},
    );
    return result.map((r) => {
      'id': r[0],
      'appointment_time': r[1],
      'status': r[2],
    }).toList();
  }

  Future<void> close() => conn.close();
}
