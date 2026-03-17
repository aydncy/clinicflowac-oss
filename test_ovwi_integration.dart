import 'dart:convert';
import 'package:dotenv/dotenv.dart';
import 'package:clinicflowac/ovwi_client.dart';

void main() async {

  final env = DotEnv()..load();

  final ovwiUrl = env['OVWI_BASE_URL'] ?? 'http://localhost:8081';

  final client = OVWIClient(ovwiUrl);

  final event = {
    'event_type': 'appointment_created',
    'clinic_id': 'clinic_test',
    'patient_id': 'patient_test',
    'doctor_id': 'doctor_test',
    'timestamp': DateTime.now().toIso8601String()
  };

  print('Sending event to OVWI...');
  print(event);

  final result = await client.sendEvent(event);

  print('OVWI response:');
  print(result);
}
