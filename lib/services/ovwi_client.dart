import 'package:http/http.dart' as http;
import 'dart:convert';

class OvwiClient {
  final String apiKey;
  final String baseUrl;

  OvwiClient({required this.apiKey, this.baseUrl = 'http://localhost:8081'});

  Future<Map<String, dynamic>> trackUsage(String endpoint, String method, int statusCode, int latencyMs) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/analytics/track'),
        headers: {'x-api-key': apiKey, 'Content-Type': 'application/json'},
        body: jsonEncode({'endpoint': endpoint, 'method': method, 'status_code': statusCode, 'latency_ms': latencyMs})
      );
      return jsonDecode(response.body);
    } catch (e) {
      print('OVWI error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUsageStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/dashboard/usage'),
        headers: {'x-api-key': apiKey}
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
