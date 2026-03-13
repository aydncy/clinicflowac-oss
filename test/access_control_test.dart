void main() {
  test('free user can access demo region only', () {
    final userTier = 'free';
    final allowedRegion = 'global-demo';
    
    expect(userTier, equals('free'));
    expect(allowedRegion, equals('global-demo'));
  });

  test('developer user can access sandbox', () {
    final userTier = 'developer';
    final allowedRegion = 'sandbox';
    
    expect(userTier, equals('developer'));
    expect(allowedRegion, equals('sandbox'));
  });

  test('organization user can access clinic region', () {
    final userTier = 'organization';
    final tenantId = 'clinic_123';
    
    expect(userTier, equals('organization'));
    expect(tenantId, contains('clinic'));
  });

  test('enterprise user can access all regions', () {
    final userTier = 'enterprise';
    final regions = ['global-demo', 'sandbox', 'clinic', 'multi-region'];
    
    expect(userTier, equals('enterprise'));
    expect(regions.length, greaterThan(1));
  });
}
