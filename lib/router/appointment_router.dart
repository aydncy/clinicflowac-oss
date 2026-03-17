import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../services/appointment_service.dart';
import '../database/database.dart';
import '../ovwi_client.dart';

class AppointmentRouter {
  final AppointmentService _appointmentService;

  AppointmentRouter(AppDatabase db, OVWIClient ovwiClient)
      : _appointmentService = AppointmentService(db, ovwiClient);

  Router get router {
    final router = Router();
    router.get('/list/<clinic_id>', _getAppointments);
    router.post('/create', _createAppointment);
    router.put('/update/<appointment_id>', _updateAppointment);
    return router;
  }

  Future<Response> _getAppointments(Request request, String clinicId) async {
    final result = await _appointmentService.getPatientAppointments(clinicId);
    if (result['success']) {
      return Response.ok(jsonEncode(result));
    } else {
      return Response.internalServerError(body: jsonEncode(result));
    }
  }

  Future<Response> _createAppointment(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      final result = await _appointmentService.createAppointment(
        clinicId: payload['clinic_id'],
        patientId: payload['patient_id'],
        doctorId: payload['doctor_id'],
        appointmentTime: DateTime.parse(payload['appointment_time']),
        reasonForVisit: payload['reason_for_visit'],
        notes: payload['notes'],
      );

      if (result['success']) {
        return Response.ok(jsonEncode(result));
      } else {
        return Response.badRequest(body: jsonEncode(result));
      }
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _updateAppointment(Request request, String appointmentId) async {
    // Update iþlemi için yeni bir metod yazýlmalý
    return Response.ok(jsonEncode({'message': 'Update endpoint will be implemented'}));
  }
}
