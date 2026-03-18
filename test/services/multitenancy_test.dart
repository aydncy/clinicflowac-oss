import 'package:test/test.dart';
import '../../lib/infrastructure/multitenancy/tenant_context.dart';
import '../../lib/infrastructure/multitenancy/tenant_context_manager.dart';

void main() {
  group('Multi-tenancy Tests', () {
    late TenantContextManager tenantManager;

    setUp(() {
      TenantContextManager.resetSingleton();
      tenantManager = TenantContextManager();
    });

    test('should add tenant', () {
      final tenant = TenantContext(
        tenantId: 't1',
        clinicId: 'c1',
        clinicName: 'Clinic One',
        region: 'TR',
        createdAt: DateTime.now(),
      );

      tenantManager.addTenant(tenant);

      final result = tenantManager.getTenant('t1');

      expect(result, isNotNull);
      expect(result!.clinicName, 'Clinic One');
    });

    test('should return all tenants', () {
      final tenant1 = TenantContext(
        tenantId: 't1',
        clinicId: 'c1',
        clinicName: 'Clinic One',
        region: 'TR',
        createdAt: DateTime.now(),
      );

      final tenant2 = TenantContext(
        tenantId: 't2',
        clinicId: 'c2',
        clinicName: 'Clinic Two',
        region: 'US',
        createdAt: DateTime.now(),
      );

      tenantManager.addTenant(tenant1);
      tenantManager.addTenant(tenant2);

      final tenants = tenantManager.getAllTenants();

      expect(tenants.length, 2);
    });
  });
}
