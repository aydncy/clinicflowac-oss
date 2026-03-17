import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import '../lib/db.dart';
import '../lib/ovwi_client.dart';

void main() async {
  final db = DB();
  await db.connect();

  final ovwi = OVWIClient('http://localhost:8081');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler((Request request) async {
    if (request.method == 'POST' && request.url.path == 'patients') {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      final id = await db.createPatient(data['name']);

      await ovwi.sendEvent(
        'patient_created',
        {'clinic_id': 'clinic_1'}
      );

      return Response.ok(jsonEncode({'id': id}));
    }

    return Response.notFound('Not Found');
  });

  final server = await io.serve(handler, 'localhost', 8082);
  print('SERVER RUNNING http://localhost:8082');
}
