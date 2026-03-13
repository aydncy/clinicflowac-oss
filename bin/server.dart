import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

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
  final router = Router();

  router.get('/health', (Request req) {
    return Response.ok(
      jsonEncode({'status': 'healthy', 'service': 'ClinicFlowAC', 'database': 'production', 'version': '1.0.0'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      return Response.ok(
        jsonEncode({
          'id': 'pat_' + DateTime.now().millisecondsSinceEpoch.toString(),
          'first_name': json['first_name'],
          'last_name': json['last_name'],
          'date_of_birth': json['date_of_birth'],
          'phone': json['phone'],
          'email': json['email'] ?? 'patient@example.eu',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients', (Request request) async {
    return Response.ok(
      jsonEncode([
        {
          'id': 'pat_001',
          'first_name': 'John',
          'last_name': 'Anderson',
          'date_of_birth': '1985-03-15',
          'phone': '+43 664 123 4567',
          'email': 'john.anderson@example.at',
          'status': 'active'
        },
        {
          'id': 'pat_002',
          'first_name': 'Maria',
          'last_name': 'Mueller',
          'date_of_birth': '1990-07-22',
          'phone': '+49 173 456 7890',
          'email': 'maria.mueller@example.de',
          'status': 'active'
        },
        {
          'id': 'pat_003',
          'first_name': 'Sophie',
          'last_name': 'Dubois',
          'date_of_birth': '1992-11-08',
          'phone': '+33 6 12 34 56 78',
          'email': 'sophie.dubois@example.fr',
          'status': 'active'
        },
      ]),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.post('/api/v1/doctors', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      return Response.ok(
        jsonEncode({
          'id': 'doc_' + DateTime.now().millisecondsSinceEpoch.toString(),
          'first_name': json['first_name'],
          'last_name': json['last_name'],
          'specialty': json['specialty'],
          'license_number': json['license_number'] ?? 'LIC' + DateTime.now().millisecondsSinceEpoch.toString(),
          'email': json['email'] ?? 'doctor@clinic.eu',
          'phone': json['phone'] ?? '+43 1 234 5678',
          'status': 'active',
          'created_at': DateTime.now().toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/doctors', (Request request) async {
    return Response.ok(
      jsonEncode([
        {
          'id': 'doc_001',
          'first_name': 'Dr. Klaus',
          'last_name': 'Bergmann',
          'specialty': 'Cardiology',
          'license_number': 'MED-DE-001234',
          'email': 'klaus.bergmann@clinic.de',
          'phone': '+49 30 555 1234',
          'status': 'active'
        },
        {
          'id': 'doc_002',
          'first_name': 'Dr. Elisabeth',
          'last_name': 'Weber',
          'specialty': 'Neurology',
          'license_number': 'MED-AT-005678',
          'email': 'elisabeth.weber@clinic.at',
          'phone': '+43 1 555 5678',
          'status': 'active'
        },
        {
          'id': 'doc_003',
          'first_name': 'Dr. Jean-Pierre',
          'last_name': 'Laurent',
          'specialty': 'Orthopedics',
          'license_number': 'MED-FR-009012',
          'email': 'jean.laurent@clinic.fr',
          'phone': '+33 1 55 12 3456',
          'status': 'active'
        },
      ]),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = await request.readAsString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      return Response.ok(
        jsonEncode({
          'id': 'apt_' + DateTime.now().millisecondsSinceEpoch.toString(),
          'patient_id': json['patient_id'],
          'doctor_id': json['doctor_id'],
          'appointment_time': json['appointment_time'],
          'duration_minutes': json['duration_minutes'] ?? 30,
          'reason_for_visit': json['reason_for_visit'] ?? 'General Checkup',
          'status': 'scheduled',
          'created_at': DateTime.now().toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  });

  router.get('/api/v1/appointments', (Request request) async {
    return Response.ok(
      jsonEncode([
        {
          'id': 'apt_001',
          'patient_id': 'pat_001',
          'doctor_id': 'doc_001',
          'appointment_time': '2026-03-20T10:00:00Z',
          'duration_minutes': 30,
          'reason_for_visit': 'Heart Checkup',
          'status': 'scheduled'
        },
        {
          'id': 'apt_002',
          'patient_id': 'pat_002',
          'doctor_id': 'doc_002',
          'appointment_time': '2026-03-21T14:30:00Z',
          'duration_minutes': 45,
          'reason_for_visit': 'Neurological Consultation',
          'status': 'scheduled'
        },
      ]),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final handler = Pipeline()
      .addMiddleware(requestLoggerMiddleware())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8083');

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);

  print('ClinicFlowAC server running on port ' + port.toString());
  print('Health: http://localhost:' + port.toString() + '/health');
}
