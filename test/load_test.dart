import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Load Testing', () {
    test('1000 concurrent requests', () async {
      final futures = List.generate(50, (i) {
        return http.get(Uri.parse('http://localhost:8082/health'));
      });

      final responses = await Future.wait(futures);

      for (var res in responses) {
        expect(res.statusCode, 200);
      }
    });
  });
}
