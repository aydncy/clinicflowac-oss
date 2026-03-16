import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

class PatientRouter {
  Router get router {
    final router = Router();
    router.get('/list/<clinic_id>', _getPatients);
    router.post('/create', _createPatient);
    router.get('/detail/<clinic_id>/<patient_id>', _getPatient);
    return router;
  }

  Future<Response> _getPatients(Request request, String clinicId) async {
    return Response.ok(jsonEncode({
      'success': true,
      'clinic_id': clinicId,
      'patients': [
        {'id': 'p1', 'name': 'Patient 1', 'email': 'p1@clinic.com'},
        {'id': 'p2', 'name': 'Patient 2', 'email': 'p2@clinic.com'},
      ],
    }));
  }

  Future<Response> _createPatient(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      return Response.ok(jsonEncode({
        'success': true,
        'patient_id': 'pat_${DateTime.now().millisecondsSinceEpoch}',
        'name': payload['name'],
        'email': payload['email'],
      }));
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getPatient(Request request, String clinicId, String patientId) async {
    return Response.ok(jsonEncode({
      'success': true,
      'patient': {
        'id': patientId,
        'clinic_id': clinicId,
        'name': 'Patient Name',
        'email': 'patient@clinic.com',
        'phone': '5551234567',
        'medical_history': [],
      },
    }));
  }
}