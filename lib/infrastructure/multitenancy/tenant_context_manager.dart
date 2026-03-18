import 'tenant_context.dart';

class TenantContextManager {
  static final Map<String, TenantContext> _tenants = {};

  static void resetSingleton() {
    _tenants.clear();
  }

  void addTenant(TenantContext tenant) {
    _tenants[tenant.tenantId] = tenant;
  }

  TenantContext? getTenant(String tenantId) {
    return _tenants[tenantId];
  }

  List<TenantContext> getAllTenants() {
    return _tenants.values.toList();
  }
}
