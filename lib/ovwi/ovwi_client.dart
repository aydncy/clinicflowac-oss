import 'dart:convert';
import 'dart:io';

Future<void> sendEvent({
  required String tenantId,
  required String clinicId,
  required String eventType,
  Map<String, dynamic>? payload,
}) async {
  try {
    final client = HttpClient();

    final request = await client.postUrl(
      Uri.parse('http://localhost:8081/webhook'),
    );

    request.headers.set('Content-Type', 'application/json');

    request.write(jsonEncode({
      'tenantId': tenantId,
      'clinicId': clinicId,
      'eventType': eventType,
      'payload': payload ?? {},
    }));

    final response = await request.close();
    await response.drain();

    client.close();
  } catch (_) {
    // isolation: DO NOTHING
  }
}
