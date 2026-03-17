import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';
import '../services/patient_service.dart';
import '../database/database.dart';
import '../ovwi_client.dart';

class PatientRouter {
  final PatientService _patientService;

  PatientRouter(AppDatabase db, OVWIClient ovwiClient)
      : _patientService = PatientService(db, ovwiClient);

  Router get router {
    final router = Router();

    router.get('/list/<clinic_id>', _getPatients);
    router.post('/create', _createPatient);
    router.get('/detail/<clinic_id>/<patient_id>', _getPatient);

    return router;
  }

  Future<Response> _getPatients(Request request, String clinicId) async {
    final result = await _patientService.getClinicPatients(clinicId);
    if (result['success']) {
      return Response.ok(jsonEncode(result), headers: {'Content-Type': 'application/json'});
    } else {
      return Response.internalServerError(body: jsonEncode(result));
    }
  }

  Future<Response> _createPatient(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final result = await _patientService.createPatient(
        clinicId: payload['clinic_id'],
        firstName: payload['first_name'],
        lastName: payload['last_name'],
        dateOfBirth: DateTime.parse(payload['date_of_birth']),
        phone: payload['phone'],
        email: payload['email'],
        bloodType: payload['blood_type'],
        allergies: payload['allergies'],
      );

      if (result['success']) {
        return Response.ok(jsonEncode(result), headers: {'Content-Type': 'application/json'});
      } else {
        return Response.badRequest(body: jsonEncode(result));
      }
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getPatient(Request request, String clinicId, String patientId) async {
    // A method needs to be written for detail
    return Response.ok(jsonEncode({'message': 'Detail endpoint will be implemented'}), headers: {'Content-Type': 'application/json'});
  }
}
