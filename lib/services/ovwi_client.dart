import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendWorkflowToOvwi(Map<String, dynamic> workflow) async {
  final url = Uri.parse("http://localhost:8080/api/v1/workflows");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(workflow),
  );

  if (response.statusCode != 200) {
    throw Exception("OVWI import failed: ${response.body}");
  }

  print("OVWI response: ${response.body}");
}
