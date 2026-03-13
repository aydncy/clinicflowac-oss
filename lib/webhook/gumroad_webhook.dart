import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;
import '../models/user.dart';
import '../models/tier.dart';

class GumroadWebhook {
  Future<shelf.Response> handlePurchase(shelf.Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final email = data['email'] as String;
      final productId = data['product_id'] as String;
      final tier = _getTierFromProductId(productId);
      final region = _getRegionForTier(tier);

      // Create user in database
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        tier: tier,
        region: region,
        tenantId: tier == 'organization' || tier == 'enterprise' 
          ? 'tenant_${DateTime.now().millisecondsSinceEpoch}' 
          : null,
        createdAt: DateTime.now(),
      );

      // Log webhook event
      print('✅ Webhook: New $tier purchase from $email');
      print('   Region: $region');
      print('   User ID: ${user.id}');

      return shelf.Response.ok(
        jsonEncode({'status': 'success', 'user_id': user.id}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return shelf.Response.internalServerError(
        body: jsonEncode({'error': e.toString()}),
      );
    }
  }

  String _getTierFromProductId(String productId) {
    // Map Gumroad product IDs to tier names
    const productTierMap = {
      'clinicflowac_free': 'free',
      'clinicflowac_developer': 'developer',
      'clinicflowac_organization': 'organization',
      'clinicflowac_enterprise': 'enterprise',
    };
    return productTierMap[productId] ?? 'free';
  }

  String _getRegionForTier(String tier) {
    const regionMap = {
      'free': 'global-demo',
      'developer': 'sandbox',
      'organization': 'clinic',
      'enterprise': 'multi-region',
    };
    return regionMap[tier] ?? 'global-demo';
  }
}
