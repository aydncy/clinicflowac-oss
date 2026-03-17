import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

class DB {
  late Connection conn;
  final uuid = Uuid();

  final String clinicId = "11111111-1111-1111-1111-111111111111";

  Future<void> connect() async {
    conn = await Connection.open(
      Endpoint(
        host: 'nozomi.proxy.rlwy.net',
        port: 44301,
        database: 'railway',
        username: 'postgres',
        password: 'oPBSQKnLeMHYHqYqWQfejsyjcPxZhiPJ',
      ),
      settings: ConnectionSettings(sslMode: SslMode.require),
    );

    print('DB connected');

    //  clinic yoksa oluştur
    await conn.execute(
      Sql.named('''
        INSERT INTO clinics (id, name)
        VALUES (@id, @name)
        ON CONFLICT (id) DO NOTHING
      '''),
      parameters: {
        'id': clinicId,
        'name': 'Test Clinic',
      },
    );

    print('CLINIC READY');
    print('TABLE READY');
  }

  Future<String> createPatient(String name) async {
    final id = uuid.v4();

    await conn.execute(
      Sql.named('''
        INSERT INTO patients (id, clinic_id, first_name, last_name)
        VALUES (@id, @clinic_id, @first_name, @last_name)
      '''),
      parameters: {
        'id': id,
        'clinic_id': clinicId,
        'first_name': name,
        'last_name': 'Test',
      },
    );

    return id;
  }

  Future<List<Map<String, dynamic>>> getPatients() async {
    final result = await conn.execute(
      Sql.named('SELECT id, first_name, last_name FROM patients'),
    );

    return result.map((row) => row.toColumnMap()).toList();
  }
}
