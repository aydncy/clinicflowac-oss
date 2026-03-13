import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/features/clinic_routes.dart';

Future<void> main() async {
  final router = Router();

  router.get('/health', (Request req) {
    return Response.ok(
      jsonEncode({'status': 'healthy', 'service': 'ClinicFlowAC', 'timestamp': DateTime.now().toIso8601String()}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final clinicRouter = clinicRoutes();

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler((request) async {
        var response = router(request);
        if (response is Response) return response;
        return clinicRouter(request);
      });

  final port = int.parse(Platform.environment['PORT'] ?? '8083');

  final server = await io.serve(handler, InternetAddress.anyIPv4, port);

  print('ClinicFlowAC server running on port ' + port.toString());
  print('Health: http://localhost:' + port.toString() + '/health');
}
