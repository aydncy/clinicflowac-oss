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
      jsonEncode({'status': 'healthy', 'service': 'ClinicFlowAC', 'version': '1.0.0'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.post('/auth/register', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final name = body['name'] as String?;
      final email = body['email'] as String?;

      if (name == null || email == null) {
        return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': 'name and email required'}));
      }

      return Response(201, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'clinic_id': 'clinic_${DateTime.now().millisecondsSinceEpoch}', 'name': name, 'email': email}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.post('/auth/login', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      final email = body['email'] as String?;

      if (email == null) {
        return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': 'email required'}));
      }

      return Response(200, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'token': 'clinic_token_${DateTime.now().millisecondsSinceEpoch}', 'clinic_id': 'clinic_123'}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.post('/api/v1/patients', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      return Response(201, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'patient_id': 'pat_${DateTime.now().millisecondsSinceEpoch}', 'name': body['name'], 'email': body['email'], 'status': 'active'}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.get('/api/v1/patients/<clinicId>', (Request request, String clinicId) async {
    try {
      return Response(200, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': [{'patient_id': 'pat_1', 'name': 'Dr. Stefan Mueller', 'email': 'stefan@example.de'}]}));
    } catch (e) {
      return Response(500, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'error': e.toString()}));
    }
  });

  router.post('/api/v1/appointments', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      return Response(201, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true, 'data': {'appointment_id': 'apt_${DateTime.now().millisecondsSinceEpoch}', 'status': 'scheduled'}}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  router.post('/api/v1/analytics/track', (Request request) async {
    try {
      final body = jsonDecode(await request.readAsString());
      return Response(200, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': true}));
    } catch (e) {
      return Response(400, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'success': false, 'error': e.toString()}));
    }
  });

  final handler = Pipeline().addMiddleware(requestLoggerMiddleware()).addHandler(router);
  await io.serve(handler, InternetAddress.anyIPv4, 8083);
  print('ClinicFlowAC server running on port 8083');
}
