import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('Load Testing', () {

    test('1000 concurrent requests', () async {

      final stopwatch = Stopwatch()..start();

      final futures = List.generate(1000, (_) async {
        final sw = Stopwatch()..start();

        final response = await http.get(
          Uri.parse('http://localhost:8083/health')
        );

        sw.stop();

        return {
          'status': response.statusCode,
          'latency': sw.elapsedMilliseconds
        };
      });

      final results = await Future.wait(futures);

      stopwatch.stop();

      final success = results.where((r) => r['status'] == 200).length;
      final latencies = results.map((r) => r['latency'] as int).toList();

      latencies.sort();

      final p50 = latencies[(latencies.length * 0.5).toInt()];
      final p95 = latencies[(latencies.length * 0.95).toInt()];
      final p99 = latencies[(latencies.length * 0.99).toInt()];

      print('🚀 Real Load Test');
      print('Requests: 1000');
      print('Success: $success');
      print('Time: ${stopwatch.elapsedMilliseconds}ms');
      print('P50: ${p50}ms');
      print('P95: ${p95}ms');
      print('P99: ${p99}ms');

      expect(success, greaterThan(900));
      expect(p99, lessThan(3000));
    });

  });
}
