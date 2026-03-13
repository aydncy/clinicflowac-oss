import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/events/event_envelope.dart';

class OvwiProof {
  final String hash;
  final String signature;
  final int sequence;
  final String previousHash;
  final DateTime timestamp;

  OvwiProof({
    required this.hash,
    required this.signature,
    required this.sequence,
    required this.previousHash,
    required this.timestamp,
  });

  factory OvwiProof.fromJson(Map<String, dynamic> json) => OvwiProof(
    hash: json['hash'] as String,
    signature: json['signature'] as String,
    sequence: json['sequence'] as int,
    previousHash: json['previous_hash'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}

class OvwiClient {
  final String baseUrl;
  final http.Client httpClient;

  OvwiClient({
    this.baseUrl = "http://localhost:8080",
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Future<OvwiProof> submitEvent(WorkflowEvent event) async {
    try {
      final response = await httpClient.post(
        Uri.parse("$baseUrl/api/v1/events"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(event.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception("OVWI error: ${response.body}");
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return OvwiProof.fromJson(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getEvent(String eventId) async {
    try {
      final response = await httpClient.get(
        Uri.parse("$baseUrl/api/v1/events/$eventId"),
      );

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        throw Exception("OVWI error: ${response.body}");
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> verifyChain() async {
    try {
      final response = await httpClient.get(
        Uri.parse("$baseUrl/api/v1/verify-chain"),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['valid'] as bool;
    } catch (e) {
      return false;
    }
  }
}
