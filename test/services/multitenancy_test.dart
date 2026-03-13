import 'package:test/test.dart';
import '../../lib/infrastructure/multitenancy/tenant_context.dart';

void main() {
  group('Multi-Tenancy Tests', () {
    late TenantContextManager tenantManager;

    setUp(() {
      TenantContextManager.resetSingleton();
      tenantManager = TenantContextManager();
    });

    test('should register tenant', () {
      final tenant = TenantContext(
        tenantId: 'clinic_001',
        clinicId: 'c_001',
        clinicName: 'Central Hospital',
        region: 'EU',
        createdAt: DateTime.now(),
      );

      tenantManager.registerTenant(tenant);
      final retrieved = tenantManager.getTenant('clinic_001');
      
      expect(retrieved, isNotNull);
      expect(retrieved?.clinicName, equals('Central Hospital'));
      print('✅ Tenant registered and retrieved');
    });

    test('should switch tenant context', () {
      final tenant1 = TenantContext(
        tenantId: 'clinic_001',
        clinicId: 'c_001',
        clinicName: 'Hospital A',
        region: 'EU',
        createdAt: DateTime.now(),
      );

      tenantManager.registerTenant(tenant1);
      tenantManager.setCurrentTenant('clinic_001');
      
      final current = tenantManager.getCurrentTenant();
      expect(current, isNotNull);
      expect(current?.tenantId, equals('clinic_001'));
      print('✅ Tenant context switched');
    });

    test('should get database name for tenant', () {
      final tenant = TenantContext(
        tenantId: 'clinic_001',
        clinicId: 'c_001',
        clinicName: 'Test Hospital',
        region: 'EU',
        createdAt: DateTime.now(),
      );

      expect(tenant.databaseName, equals('clinic_clinic_001_db'));
      expect(tenant.schemaName, equals('tenant_clinic_001'));
      print('✅ Database naming correct');
    });

    test('should get tenant statistics', () {
      final tenant1 = TenantContext(
        tenantId: 'clinic_001',
        clinicId: 'c_001',
        clinicName: 'Hospital A',
        region: 'EU',
        createdAt: DateTime.now(),
      );

      final tenant2 = TenantContext(
        tenantId: 'clinic_002',
        clinicId: 'c_002',
        clinicName: 'Hospital B',
        region: 'ASIA',
        createdAt: DateTime.now(),
      );

      tenantManager.registerTenant(tenant1);
      tenantManager.registerTenant(tenant2);
      tenantManager.setCurrentTenant('clinic_001');

      final stats = tenantManager.getTenantStats();
      expect(stats['totalTenants'], equals(2));
      expect(stats['activeTenants'], equals(2));
      print('✅ Tenant stats retrieved');
    });

    test('should deactivate tenant correctly', () {
      final tenant = TenantContext(
        tenantId: 'clinic_001',
        clinicId: 'c_001',
        clinicName: 'Hospital A',
        region: 'EU',
        createdAt: DateTime.now(),
        active: true,
      );

      tenantManager.registerTenant(tenant);
      
      expect(tenantManager.getTenant('clinic_001')?.active, true);
      tenantManager.deactivateTenant('clinic_001');
      expect(tenantManager.getTenant('clinic_001')?.active, false);
      
      final stats = tenantManager.getTenantStats();
      expect(stats['activeTenants'], equals(0));
      print('✅ Tenant deactivated correctly');
    });
  });
}
