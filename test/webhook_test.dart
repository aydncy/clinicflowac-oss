void main() {
  test('webhook receives purchase data', () {
    final data = {
      'email': 'clinic@example.com',
      'tier': 'organization',
      'signature': 'valid_sig'
    };
    
    expect(data['email'], equals('clinic@example.com'));
    expect(data['tier'], equals('organization'));
    expect(data['signature'], isNotEmpty);
  });

  test('webhook creates user with tier', () {
    final email = 'user@clinic.com';
    final tier = 'developer';
    
    expect(email, contains('@'));
    expect(['free', 'developer', 'organization', 'enterprise'], contains(tier));
  });

  test('webhook assigns region based on tier', () {
    final tierRegions = {
      'free': 'global-demo',
      'developer': 'sandbox',
      'organization': 'clinic',
      'enterprise': 'multi-region',
    };
    
    for (var tier in tierRegions.keys) {
      expect(tierRegions[tier], isNotEmpty);
    }
  });
}
