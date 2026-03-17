import 'package:shelf/shelf.dart';
import '../services/auth_service.dart';

Middleware jwtMiddleware() {
  return (innerHandler) {
    return (request) async {
      if (request.url.path == 'health' || request.url.path == 'auth/register' || request.url.path == 'auth/login') {
        return innerHandler(request);
      }
      final authHeader = request.headers['authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized('Missing authorization header');
      }
      final token = authHeader.substring(7);
      final payload = AuthService.verifyToken(token);
      if (payload == null) {
        return Response.unauthorized('Invalid token');
      }
      final updatedRequest = request.change(context: {'user_id': payload['sub'], 'clinic_id': payload['clinic_id'], 'role': payload['role'], 'email': payload['email'],});
      return innerHandler(updatedRequest);
    };
  };
}

String getUserId(Request request) => request.context['user_id'] as String;
String getClinicId(Request request) => request.context['clinic_id'] as String;
String getRole(Request request) => request.context['role'] as String;
String getEmail(Request request) => request.context['email'] as String;
