import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/auth_service.dart';

class ClinicRouter {
  Router get router {
    final router = Router();
    router.get('/health', _healthCheck);
    router.post('/register', _register);
    return router;
  }

  Future<Response> _healthCheck(Request request) async {
    return Response.ok(
      jsonEncode({'status': 'ok', 'service': 'clinicflowac'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<Response> _register(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final name = payload['name'] as String?;
      final email = payload['email'] as String?;
      final password = payload['password'] as String?;

      if (name == null || email == null || password == null) {
        return Response.badRequest(body: jsonEncode({'error': 'Missing fields'}));
      }

      final accessToken = AuthService.generateToken(
        'user-123',
        'clinic-456',
        email,
        'admin',
      );

      final refreshToken = AuthService.generateToken(
        'user-123',
        'clinic-456',
        email,
        'admin',
        isRefresh: true,
      );

      return Response.ok(
        jsonEncode({
          'success': true,
          'clinic_id': 'clinic-456',
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'user': {
            'id': 'user-123',
            'email': email,
            'role': 'admin',
          },
        }),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError();
    }
  }
}
