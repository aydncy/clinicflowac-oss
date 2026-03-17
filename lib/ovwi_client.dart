import 'dart:convert';
import 'package:http/http.dart' as http;

class OVWIClient {
  final String baseUrl;

  OVWIClient(this.baseUrl);

  Future<void> sendEvent(String eventType, Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/webhooks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'event': eventType,
          'data': data,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      print('OVWI STATUS: ${res.statusCode}');
    } catch (e) {
      print('OVWI OFFLINE');
    }
  }
}
