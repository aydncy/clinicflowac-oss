import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  const baseUrl = "http://localhost:8080";

  final workflowId = "clinic-cli-1";
  final eventId =
      DateTime.now().millisecondsSinceEpoch.toString();

  print("Sending event to OVWI...");

  final response = await http.post(
    Uri.parse("$baseUrl/api/v1/workflows"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "workflow_id": workflowId,
      "event_id": eventId,
      "type": "appointment_created",
      "patient_id": "P-CLI-001"
    }),
  );

  print("Event response:");
  print(response.body);

  print("\nFetching proof...");

  final proofResponse = await http.get(
    Uri.parse("$baseUrl/api/v1/proof/$workflowId"),
  );

  print("Proof:");
  print(proofResponse.body);
}