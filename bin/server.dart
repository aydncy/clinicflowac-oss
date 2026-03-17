import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'dart:io';
import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import '../lib/router/clinic_router.dart';
import '../lib/router/payment_router.dart';
import '../lib/router/patient_router.dart';
import '../lib/router/appointment_router.dart';

void main() async {
  final env = DotEnv()..load();
  final port = int.parse(env['CLINICFLOW_PORT'] ?? '8083');
  final host = InternetAddress.anyIPv4;
  
  final clinicRouter = ClinicRouter();
  final paymentRouter = PaymentRouter();
  final patientRouter = PatientRouter();
  final appointmentRouter = AppointmentRouter();
  
  final router = Router()
    ..mount('/auth', clinicRouter.router)
    ..mount('/payments', paymentRouter.router)
    ..mount('/patients', patientRouter.router)
    ..mount('/appointments', appointmentRouter.router)
    ..get('/health', (_) => Response.ok(jsonEncode({'status': 'ok'})));
  
  final handler = logRequests()(router);
  
  final server = await shelf_io.serve(handler, host, port);
  print('ClinicFlowAC running on port: $port');
}