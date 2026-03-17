import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:convert';

class PaymentRouter {
  Router get router {
    final router = Router();
    router.post('/create-payment-intent', _createPaymentIntent);
    return router;
  }

  Future<Response> _createPaymentIntent(Request request) async {
    try {
      final payload = jsonDecode(await request.readAsString());
      return Response.ok(jsonEncode({
        'success': true,
        'payment_id': 'pi_test_${DateTime.now().millisecondsSinceEpoch}',
        'amount': payload['amount'],
        'clinic_id': payload['clinic_id'],
        'status': 'pending',
      }));
    } catch (e) {
      return Response.badRequest(body: jsonEncode({'error': e.toString()}));
    }
  }
}
