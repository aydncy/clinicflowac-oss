import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

class AppointmentRouter {
  Router get router {
    final router = Router();
    router.get('/list/<clinic_id>', _getAppointments);
    router.post('/create', _createAppointment);
    router.put('/update/<appointment_id>', _updateAppointment);
    return router;
  }

  Future<Response> _getAppointments(Request request, String clinicId) async {
    return Response.ok(jsonEncode({
      'success': true,
      'clinic_id': clinicId,
      'appointments': [
        {
          'id': 'apt1',
          'patient_id': 'p1',
          'doctor_id': 'd1',
          'date': '2026-03-20T10:00:00Z',
          'status': 'scheduled',
        },
      ],
    }));
  }

  Future<Response> _createAppointment(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      return Response.ok(jsonEncode({
        'success': true,
        'appointment_id': 'apt_${DateTime.now().millisecondsSinceEpoch}',
        'patient_id': payload['patient_id'],
        'date': payload['date'],
        'status': 'scheduled',
      }));
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _updateAppointment(Request request, String appointmentId) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      return Response.ok(jsonEncode({
        'success': true,
        'appointment_id': appointmentId,
        'status': payload['status'],
      }));
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }
}