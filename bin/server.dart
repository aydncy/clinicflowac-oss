import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

Middleware requestLoggerMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final start = DateTime.now();
      final response = await handler(request);
      final duration = DateTime.now().difference(start).inMilliseconds;
      print('[${request.method}] ${request.requestedUri.path} › ${response.statusCode} (${duration}ms)');
      return response;
    };
  };
}

Future<void> main() async {
  final env = DotEnv()..load();
  Connection? connection;

  try {
    connection = await Connection.open(
      Endpoint(
        host: env['DB_HOST'] ?? 'localhost',
        port: int.parse(env['DB_PORT'] ?? '5432'),
        database: env['DB_NAME'] ?? 'ovwi_dev',
        username: env['DB_USER'] ?? 'postgres',
        password: env['DB_PASSWORD'] ?? 'postgres'
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    print('✅ PostgreSQL connected');
  } catch (e) {
    print('⚠️ Database: $e (using mock mode)');
  }

  final router = Router();

  router.get('/health', (Request req) {
    return Response.ok(
      jsonEncode({'status': 'healthy', 'service': 'ClinicFlowAC', 'database': 'production', 'version': '1.0.0'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.post('/auth/register', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final name = body['name'] as String?;
      final email = body['email'] as String?;
      final phone = body['phone'] as String?;
      final address = body['address'] as String?;

      if (name == null || email == null) {
        return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': 'name and email required'}));
      }

      if (connection != null) {
        try {
          final result = await connection.execute(
            Sql.named('INSERT INTO clinics (id, name, email, phone, address, created_at) VALUES (gen_random_uuid(), @name, @email, @phone, @address, NOW()) RETURNING id, name, email, phone, address, created_at'),
            parameters: {'name': name, 'email': email, 'phone': phone, 'address': address}
          );
          final row = result.first;
          return Response(201, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'clinic_id': row[0], 'name': row[1], 'email': row[2], 'phone': row[3], 'address': row[4], 'created_at': (row[5] as DateTime).toIso8601String()}}));
        } catch (dbError) {
          return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': dbError.toString()}));
        }
      }

      return Response(201, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'clinic_id': 'clinic_${DateTime.now().millisecondsSinceEpoch}', 'name': name, 'email': email, 'phone': phone, 'address': address}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.post('/auth/login', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final email = body['email'] as String?;
      final password = body['password'] as String?;

      if (email == null || password == null) {
        return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': 'email and password required'}));
      }

      return Response(200, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'token': 'clinic_token_${DateTime.now().millisecondsSinceEpoch}', 'clinic_id': 'clinic_123'}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      return Response.ok(
        jsonEncode({'success': true, 'data': {'patient_id': 'pat_${DateTime.now().millisecondsSinceEpoch}', 'name': body['name'], 'email': body['email'], 'status': 'active'}}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients/<clinicId>', (Request request, String clinicId) async {
    try {
      return Response.ok(
        jsonEncode({'success': true, 'data': [{'patient_id': 'pat_1', 'name': 'John Doe', 'email': 'john@example.com'}]}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      return Response.ok(
        jsonEncode({'success': true, 'data': {'appointment_id': 'apt_${DateTime.now().millisecondsSinceEpoch}', 'status': 'scheduled'}}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  final handler = Pipeline().addMiddleware(requestLoggerMiddleware()).addHandler(router);
  await io.serve(handler, InternetAddress.anyIPv4, 8083);
  print('ClinicFlowAC server running on port 8083');
  print('Health: http://localhost:8083/health');
}

