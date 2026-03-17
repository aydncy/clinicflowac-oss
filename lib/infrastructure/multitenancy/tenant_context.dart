class TenantContext {
  final String tenantId;
  final String clinicId;
  final String clinicName;
  final String region;
  final DateTime createdAt;
  bool active;
  final Map<String, dynamic> metadata;

  TenantContext({
    required this.tenantId,
    required this.clinicId,
    required this.clinicName,
    required this.region,
    required this.createdAt,
    this.active = true,
    this.metadata = const {},
  });

  String get databaseName => 'clinic_${tenantId}_db';
  
  String get schemaName => 'tenant_$tenantId';

  
    'tenantId': tenantId,
    'clinicId': clinicId,
    'clinicName': clinicName,
    'region': region,
    'createdAt': createdAt.toIso8601String(),
    'active': active,
    'databaseName': databaseName,
    'schemaName': schemaName,
    'metadata': metadata,
  };
}

class TenantContextManager {
  static TenantContextManager? _instance;
  
  final Map<String, TenantContext> _tenants = {};
  TenantContext? _currentTenant;

  factory TenantContextManager() {
    _instance ??= TenantContextManager._internal();
    return _instance!;
  }

  TenantContextManager._internal();

  void registerTenant(TenantContext tenant) {
    _tenants[tenant.tenantId] = tenant;
    print('✅ Tenant registered: ${tenant.clinicName} (${tenant.tenantId})');
  }

  void setCurrentTenant(String tenantId) {
    final tenant = _tenants[tenantId];
    if (tenant == null) {
      throw Exception('Tenant not found: $tenantId');
    }
    _currentTenant = tenant;
    print('🔄 Tenant switched: ${tenant.clinicName}');
  }

  TenantContext? getCurrentTenant() => _currentTenant;

  TenantContext? getTenant(String tenantId) => _tenants[tenantId];

  List<TenantContext> getAllTenants() => _tenants.values.toList();

  int getTenantCount() => _tenants.length;

  Map<String, dynamic> getTenantStats() {
    return {
      'totalTenants': _tenants.length,
      'activeTenants': _tenants.values.where((t) => t.active).length,
      'currentTenant': _currentTenant?.tenantId ?? 'none',
      'tenants': _tenants.values.map((t) => t.toJson()).toList(),
    };
  }

  void deactivateTenant(String tenantId) {
    final tenant = _tenants[tenantId];
    if (tenant != null) {
      tenant.active = false;
      print('⛔ Tenant deactivated: $tenantId');
    }
  }

  void deleteTenant(String tenantId) {
    _tenants.remove(tenantId);
    print('🗑️ Tenant deleted: $tenantId');
  }

  static void resetSingleton() {
    _instance = null;
  }
}
