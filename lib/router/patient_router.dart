import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

final List<Map<String, dynamic>> patients = [];

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
      'patients': patients,
    }), headers: {'Content-Type': 'application/json'});
  }

  Future<Response> _createPatient(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());

      final patient = {
        'id': 'pat_' + DateTime.now().millisecondsSinceEpoch.toString(),
        'name': payload['name'],
        'email': payload['email']
      };

      patients.add(patient);

      return Response.ok(jsonEncode({
        'success': true,
        'patient': patient
      }), headers: {'Content-Type': 'application/json'});

    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getPatient(Request request, String clinicId, String patientId) async {

    final patient = patients.firstWhere(
      (p) => p['id'] == patientId,
      orElse: () => {},
    );

    if (patient.isEmpty) {
      return Response.notFound(jsonEncode({'error': 'Patient not found'}));
    }

    return Response.ok(jsonEncode({
      'success': true,
      'patient': patient
    }), headers: {'Content-Type': 'application/json'});
  }

}
