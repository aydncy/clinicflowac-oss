import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:io';
import 'package:dotenv/dotenv.dart';
import '../lib/router/clinic_router.dart';

void main() async {
  final env = DotEnv()..load();
  final port = int.parse(env['CLINICFLOW_PORT'] ?? '8083');
  final host = InternetAddress.anyIPv4;
  
  final clinicRouter = ClinicRouter();
  final handler = logRequests()(clinicRouter.router);
  
  final server = await shelf_io.serve(handler, host, port,);
  print('ClinicFlowAC running on port: ' + port.toString());
}