import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendEvent({
  required String tenantId,
  required String eventType,
  required Map<String, dynamic> payload,
  required String apiKey,
}) async {
  try {
    await http.post(
      Uri.parse('http://localhost:8081/webhook'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
      },
      body: jsonEncode({
        'tenantId': tenantId,
        'eventType': eventType,
        'payload': payload,
      }),
    );
  } catch (e) {
    // fail silently › sistem crash etmesin
  }
}
